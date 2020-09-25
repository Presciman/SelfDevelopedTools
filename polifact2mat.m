function polifact2mat()
    %data_real = readtable('PolitiFact_real_news_content.csv');
    %data_fake = readtable('PolitiFact_fake_news_content.csv');
    %csv-> mat:
    %{
        id -> ids
        url -> url
        text -> textT
        length(text) -> textF
        title -> titleT
        length(title) -> titleF
        publish_date -> publish_date
        label3 real ? 1 : 0
    %}
    
    %rfilename = 'PolitiFact_real_news_content.csv';
    %ffilename = 'PolitiFact_fake_news_content.csv';
    
    rfilename = 'BuzzFeed_real_news_content.csv';
    ffilename = 'BuzzFeed_fake_news_content.csv';
    
    ropts = detectImportOptions(rfilename);
    ropts.ImportErrorRule = 'omitrow';
    ropts.MissingRule = 'fill';
    fopts = detectImportOptions(ffilename);
    fopts.ImportErrorRule = 'omitrow';
    fopts.MissingRule = 'fill';
    real_full = readtable(rfilename,ropts);
    %real_full.Properties.VariableNames{'id'} = 'ids';
    %real_full.Properties.VariableNames{'title'} = 'titleT';
    fake_full = readtable(ffilename,fopts);
    %fake_full.Properties.VariableNames{'id'} = 'ids';
    %fake_full.Properties.VariableNames{'title'} = 'titleT';
    
    %remove stop words
    rtextT = cell(length(real_full.text),1);
    rtextF = cell(length(real_full.text),1);
    rlabel3 = cell(length(real_full.text),1);
    words = stopWords;
    for i=1:length(real_full.text)
        document = tokenizedDocument(real_full.text{i});
        document1 = removeWords(document,words);
        cell_line = doc2cell(document1);
        rtextT{i} = cellstr(cell_line{1,1});
        rtextF{i} = length(rtextT{i});
        rlabel3{i} = 1;
    end
    
    %remove stop words
    ftextT = cell(length(fake_full.text),1);
    ftextF = cell(length(fake_full.text),1);
    flabel3 = cell(length(fake_full.text),1);
    words = stopWords;
    disp(size(real_full));
    disp(size(fake_full));
    for i=1:length(fake_full.text)
        document = tokenizedDocument(fake_full.text{i});
        document1 = removeWords(document,words);
        cell_line = doc2cell(document1);
        ftextT{i} = cellstr(cell_line{1,1});
        ftextF{i} = length(ftextT{i});
        flabel3{i} = 0;
    end
    ids = string([real_full.id;fake_full.id]);
    url = [real_full.url;fake_full.url];
    textT = [rtextT;ftextT];
    textF = cell2mat([rtextF;ftextF]);
    titleT = [real_full.title;fake_full.title];
    titleF = cell(length(titleT),1);
    for i=1:length(titleT)
        titleF{i} = length(titleT{i});
    end
    titleF = cell2mat(titleF);
    publish_date = [real_full.publish_date;fake_full.publish_date];
    label3 = cell2mat([rlabel3;flabel3]);
    news = table(ids,url,textT,textF,titleT,titleF,publish_date,label3);
    randIdx_news = randperm(size(news,1));
    news = news(randIdx_news,:);
    %For politifact, 120real 120fake
    %save('politifact.mat','-V7.3','news');
    %For buzzfed, 91real 91fake
    save('buzzfed.mat','-V7.3','news');
end