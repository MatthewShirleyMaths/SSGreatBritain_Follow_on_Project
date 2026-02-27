function [s, RH] = load_arclength_rh(filename, saveMat)
% LOAD_ARCLENGTH_RH  Read arc length and Relative Humidity from COMSOL .txt export
%   [s, RH] = load_arclength_rh(filename) reads the two columns from the
%   text file and returns them as column vectors (Nx1).
%
%   [s, RH] = load_arclength_rh(filename, true) also saves variables to
%   'filename_mat.mat' (same base name) for quick use in MATLAB.
%
% Example:
%   [s, RH] = load_arclength_rh('/mnt/data/test.txt', true);
%
% The function ignores lines starting with '%' and any non-numeric header.

if nargin < 1 || isempty(filename)
    error('Please provide the path to the text file.');
end
if nargin < 2
    saveMat = false;
end

% Try modern readmatrix first (handles comment lines)
try
    opts = detectImportOptions(filename,'FileType','text');
    % Tell import to treat '%' as comment (if detectImportOptions didn't)
    opts = setvaropts(opts,opts.VariableNames,'CommentStyle','%');
    % Use readmatrix with comment handling fallback
    data = readmatrix(filename,'FileType','text','CommentStyle','%','Delimiter',{' ','\t',','},'MultipleDelimsAsOne',true);
catch
    % Fallback: manual read (robust)
    fid = fopen(filename,'r');
    if fid == -1
        error('Failed to open file: %s', filename);
    end
    data = [];
    while ~feof(fid)
        tline = fgetl(fid);
        if isempty(tline), continue; end
        t = strtrim(tline);
        if isempty(t), continue; end
        if t(1) == '%', continue; end          % skip comment header lines
        % Try to scan two floats
        nums = sscanf(t, '%f %f');
        if numel(nums) == 2
            data(end+1,1:2) = nums(:)'; %#ok<AGROW>
        else
            % try to extract with regexp (handles multiple spaces/tabs)
            tokens = regexp(t, '([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)', 'match');
            if numel(tokens) >= 2
                a = str2double(tokens{1});
                b = str2double(tokens{2});
                if ~isnan(a) && ~isnan(b)
                    data(end+1,1:2) = [a b]; %#ok<AGROW>
                end
            end
        end
    end
    fclose(fid);
end

% Clean up (remove any NaN rows)
if isempty(data)
    error('No numeric data found in file: %s', filename);
end
data = data(~any(isnan(data),2), :);

% Return column vectors
s  = data(:,1);
RH = data(:,2);

% Ensure column vectors
s  = s(:);
RH = RH(:);

% Optionally save to .mat (same base filename)
if saveMat
    [p, n, ~] = fileparts(filename);
    outname = fullfile(p, [n '_mat.mat']);
    save(outname, 's', 'RH');
    fprintf('Saved variables to %s\n', outname);
end
end