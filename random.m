function r = random(max, min, varargin)

numvarargin = length(varargin);
if numvarargin==2 
    n = varargin{1};
    m = varargin{2};
elseif numvarargin==1
    n = varargin{1};
    m = n;
elseif numvarargin==0
    n = 1;
    m = 1;
end

range = max-min;
r = min + rand(n,m)*range;