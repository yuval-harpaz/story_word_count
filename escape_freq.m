function tm = escape_freq(words)
cdd
cd EscapePod
load dataAll dataAll wie wip win epName pcName nyName
if false
    for ii = 1:length(dataAll)
        n(ii,1) = sum([wie(ii,:),wip(ii,:),win(ii,:)]);
    end
    word = dataAll(n > 1);
    wie(n == 1,:) = [];
    win(n == 1,:) = [];
    wip(n == 1,:) = [];
    wo = find(ismember(word,'wo'));
    word(wo) = [];
    wie(wo,:) = [];
    win(wo,:) = [];
    wip(wo,:) = [];
    strr = 'tt = table(word,';
    for ii = 1:54
        eval(['EP',str(ii),' = uint8(wie(:,ii));'])
        strr = [strr,'EP',str(ii),','];
    end
    for ii = 1:32
        eval(['PC',str(ii),' = uint8(wip(:,ii));'])
        strr = [strr,'PC',str(ii),','];
    end
    for ii = 1:48
        eval(['NY',str(ii),' = uint8(win(:,ii));'])
        strr = [strr,'NY',str(ii),','];
    end
    eval([strr(1:end-1),');']);
    writetable(tt,'word_in_story.csv','delimiter',',','WriteVariableNames',true);
end
tt = readtable('word_in_story.csv');
win = tt{:,find(contains(tt.Properties.VariableNames,'NY'))} == 1;
wip = tt{:,find(contains(tt.Properties.VariableNames,'PC'))} == 1;
wie = tt{:,find(contains(tt.Properties.VariableNames,'EP'))} == 1;

fig5 = figure;
[score,adv] = sort(mean(win,2) - (mean(wie,2) + mean(wip,2))/2,'descend');
w = tt.word(adv(1:100));
c = score(1:100);
word = cell(300,1);
EP = nan(300,1);
PC = nan(300,1);
NY = nan(300,1);
word(201:300) = w;
EP(201:300) = mean(wie(adv(1:100),:),2);
PC(201:300) = mean(wip(adv(1:100),:),2);
NY(201:300) = mean(win(adv(1:100),:),2);
subplot(2,2,3)
wordcloud(w,c,'HighlightColor','k');
title('The New Yorker - (Escape Pod + Pod Castle)/2')
[score,adv] = sort(mean(wie,2) - mean(wip,2),'descend');
w = tt.word(adv(1:100));
c = score(1:100);
word(1:100) = w;
EP(1:100) = mean(wie(adv(1:100),:),2);
PC(1:100) = mean(wip(adv(1:100),:),2);
NY(1:100) = mean(win(adv(1:100),:),2);
subplot(2,2,1)
wordcloud(w,c,'HighlightColor','k');
title('Escape Pod - Pod Castle')
[score,adv] = sort(mean(wip,2) - mean(wie,2),'descend');
w = tt.word(adv(1:100));
c = score(1:100);
word(101:200) = w;
EP(101:200) = mean(wie(adv(1:100),:),2);
PC(101:200) = mean(wip(adv(1:100),:),2);
NY(101:200) = mean(win(adv(1:100),:),2);
subplot(2,2,2)
wordcloud(w,c,'HighlightColor','k');
title('Pod Castle - Escape Pod')
[score,adv] = sort((mean(wie,2) + mean(wip,2))/2-mean(win,2),'descend');
w = tt.word(adv(1:100));
c = score(1:100);
subplot(2,2,4)
wordcloud(w,c,'HighlightColor','k');
title('(Escape Pod + Pod Castle)/2 - The New Yorker')
if exist('words','var')
    iEnd = length(EP);
    word(end+1:end+length(words)) = words;
    [isx,idx] = ismember(words,tt.word);
    EP(iEnd+1:iEnd+length(words)) = nan;
    EP(iEnd+find(isx)) = mean(wie(idx(isx),:),2);
    PC(iEnd+1:iEnd+length(words)) = nan;
    PC(iEnd+find(isx)) = mean(wip(idx(isx),:),2);
    NY(iEnd+1:iEnd+length(words)) = nan;
    NY(iEnd+find(isx)) = mean(win(idx(isx),:),2);
end
tm = table(word,EP,PC,NY);
% writetable(tm,'word_freq.csv','delimiter',',','WriteVariableNames',true);