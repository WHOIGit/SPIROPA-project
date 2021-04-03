load \\sosiknas1\IFCB_products\SPIROPA\summary\count_biovol_size_manual_05Oct2020.mat

tt = find(ismember(meta_data.cast, [163 167]))
c = strmatch('Phaeocystis', classes)
summary.count(tt,c)

countgt2blobs = NaN(length(tt),1);
for ii = 1:length(tt)
    countgt2blobs(ii) = sum(summary.numBlobs{tt(ii),c}>2);
end

%%
depth = meta_data.depth(tt); 
cast = meta_data.cast(tt);
ml = meta_data.ml_analyzed(tt);
unqcast = unique(cast);
n = 1;
for ii = 1:length(unqcast)
    ind = find(cast == unqcast(ii));
    unqd = unique(depth(ind));
    for iii = 1:length(unqd)
        ind2 = find(depth(ind) == unqd(iii));
        countgt2blobs_sum(n,1) = sum(countgt2blobs(ind(ind2)));
        ml_sum(n,1) = sum(ml(ind(ind2)));
        depth_sum(n,1) = unqd(iii);
        cast_sum(n,1) = unqcast(ii);
        n = n + 1;
    end
end

[cast depth countgt2blobs]

[cast_sum depth_sum countgt2blobs_sum ml_sum]


