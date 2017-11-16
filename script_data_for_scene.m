%nyufile = fullfile('/work4/sgupta/tmp/splitBias/sparse_contour_gradients/nyu_v2/', 'nyu_depth_v2_labeled.mat');
nyufile = 'nyu_depth_v2_labeled.mat';
%outDir = fullfile('/work5', 'sgupta', 'datasets', 'nyud2', 'datacopy');
outDir = fullfile('C:\');
mkdir(fullfile(outDir, 'rawdepth'));
mkdir(fullfile(outDir, 'depth'));
mkdir(fullfile(outDir, 'images'));

load(nyufile, 'sceneTypes');
load(nyufile, 'scenes');

%%
uniqueSceneTypes = sort(unique(sceneTypes));
disp(uniqueSceneTypes);

%%
promptSceneType = strcat('Select one of the scene types [', uniqueSceneTypes(1), ']:');
strSceneType = input(promptSceneType{1},'s');
if isempty(strSceneType)
    strSceneType = uniqueSceneTypes{1};
end

%%

regExScene = strcat('^', strSceneType, '_\d{4}');
sceneIndexes = find(cellfun('length',regexp(scenes, regExScene)) == 1);

uniqueScenes = sort(unique(scenes(sceneIndexes)));
disp(uniqueScenes);

%%
promptScene = strcat('Select one of the scenes [', uniqueScenes(1), ']:');
strScene = input(promptScene{1},'s');
if isempty(strScene)
    strScene = uniqueScenes{1};
end

%%

regExSelectedScene = strcat('^', strScene, '$');
matchingSceneIndexes = find(cellfun('length',regexp(scenes, regExSelectedScene)) == 1);

%%

dt = load(nyufile, 'rawDepths');
for i = 1:1449, 
  imwrite(uint16(cropIt(dt.rawDepths(:,:,i))*1000), fullfile(outDir, 'rawdepth', sprintf('img_%04d.png', i + 5000))); 
end

dt = load(nyufile, 'depths');
for i = 1:1449, 
  imwrite(uint16(cropIt(dt.depths(:,:,i))*1000), fullfile(outDir, 'depth', sprintf('img_%04d.png', i + 5000))); 
end

dt = load(nyufile, 'images');
for i = 1:1449, 
  imwrite(uint8(cropIt(dt.images(:,:,:,i))), fullfile(outDir, 'images', sprintf('img_%04d.png', i + 5000))); 
end
