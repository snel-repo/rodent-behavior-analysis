function [dirDir] = recursiveDir(basedir)

excludeFolders = {'.', '..', 'arch', 'ARCHV'};
parentDir = dir(basedir);
parentDir = {parentDir.name};
parentDir = parentDir(3:end);
subfoldersFlag = 0; % 0 when subfolders remain


% for i = 1:length(parentDir)
%     tmpDir = dir(parentDir);
%     tmpDir = 