function [ctrl] = gen_ctrl(len,type)
    if nargin<2
        type='ctrl_delay';
    end;
    switch type
        case 'ctrl_delay'
            d_ctrl=repmat(1-eye(16),len+10,1);
            d_ctrl=fliplr(d_ctrl);
            
            t=0:size(d_ctrl,1)+2;
            ctrl=[ones(2,16);d_ctrl;ones(1,16)];
            ctrl=[t' ctrl];
        case 'ctrl'
            d_ctrl=repmat([0 ones(1,15)],len+10,1);
            d_ctrl=d_ctrl';
            d_ctrl=d_ctrl(:);
            
            t=0:size(d_ctrl,1)+2;
            ctrl=[ones(2,1);d_ctrl;ones(1,1)];
            ctrl=[t' ctrl];
    end;