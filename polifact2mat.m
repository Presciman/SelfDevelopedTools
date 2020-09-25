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
    
    rfilename = 'PolitiFact_real_news_content1.csv';
    ffilename = 'PolitiFact_fake_news_content1.csv';
    
    %rfilename = 'BuzzFeed_real_news_content.csv';
    %ffilename = 'BuzzFeed_fake_news_content.csv';
    
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
    words = [stopWords "[" "…" "©" "×" "-" "'" "‘" "’" "“" "”" "!" "@" "#" "$" "%" "^" "&" "*" "(" ")" "<" ">" "?" ":" '"' "/" "\" "+" "=" "_" "," "]" "." "|" "A" "—" "it's"];
    for i=1:length(real_full.text)
        %rtext_line = regexprep(real_full.text{i},'[|©×–—‘’“…!@#$%^&*()<>?:"/\+=_]','')
        document = tokenizedDocument(real_full.text(i,:));
        document1 = removeWords(document,words);
        cell_line = doc2cell(document1);
        rtextT{i} = cellstr(cell_line{1,1});
        for j=1:length(rtextT(i,:))
            rtextT{i,1}{1,j} = regexprep(rtextT{i,1}{1,j},'[…|©×–—‘’“…!@#$%^&*()<>?:"/\+=_,,]','');
            if length(rtextT{i,1}{1,j})>20 || length(rtextT{i,1}{1,j})<3
                rtextT{i,1}{1,j} = [''];
            end
        end
        rtextT{i} = cellstr(rtextT{i});
        rtextF{i} = length(rtextT{i});
        rlabel3{i} = 1;
    end
    
    %remove stop words
    ftextT = cell(length(fake_full.text),1);
    ftextF = cell(length(fake_full.text),1);
    flabel3 = cell(length(fake_full.text),1);
    for i=1:length(fake_full.text)
        %ftext_line = regexprep(fake_full.text{i},'[|©×–—‘’“…!@#$%^&*()<>?:"/\+=_,.0-9]','')
        document = tokenizedDocument(fake_full.text(i,:));
        document1 = removeWords(document,words);
        cell_line = doc2cell(document1);
        ftextT{i} = cellstr(cell_line{1,1});
        for j=1:length(ftextT(i,:))
            ftextT{i,1}{1,j} = regexprep(ftextT{i,1}{1,j},'[|©×–—‘’“…!@#$%^&*()<>?:"/\+=_]','');
            if length(ftextT{i,1}{1,j})>20 || length(ftextT{i,1}{1,j})<3
                ftextT{i,1}{1,j} = [''];
            end
        end
        ftextT{i} = cellstr(ftextT{i});
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
    %average_length = mean(textF);
    publish_date = [real_full.publish_date;fake_full.publish_date];
    label3 = cell2mat([rlabel3;flabel3]);
    news = table(ids,url,textT,textF,titleT,titleF,publish_date,label3);
    
    idx_filter = find(textF<120);
    
    randIdx_news = idx_filter(randperm(size(idx_filter,1)));
    news = news(randIdx_news,:);
    idx_real = find(news.label3 == 1);
    idx_fake = find(news.label3 == 0);
    %For politifact, 120real 120fake
    save('politifact_toy.mat','-V7.3','news');
    %For buzzfed, 91real 91fake
    %save('buzzfed.mat','-V7.3','news');
end
