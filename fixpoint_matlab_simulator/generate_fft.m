function [fft_func]=generate_fft(lfft,m,index,w,rfft,n)
    w=int16(w.*2^14);

    % bypass: bypass parameter for each class
    % ordertest: set to test the order of input and output fft data
    function [result]=fftn(data,bypass,ordertest)
        
        if nargin==1
            bypass=zeros(1,log2(m*n));
            ordertest=false;
        elseif nargin==2
            ordertest=false;
        end;
        
        % if ordertest and no bypass for entire fft,
        % output fft order is the same as the input order
        if ordertest&&~bypass(1)
            result=data;
        else
            % do left-side fft
            left_outputs=int16(zeros(n,m));
            parfor i=1:n
                left_outputs(i,:)=lfft(data(i:n:end),bypass(1:log2(m)),ordertest);
            end;
            left_outputs=left_outputs.';
            
            % do twiddle factor adjustment,
            % if left-size fft is partially bypassed, the twiddle factor is recalculated
            % if left-side fft is totally bypassed, multiplication is bypassed
            % if ordertest is set, multiplication is also bypassed
            right_inputs=complexmul(left_outputs,w_bypassed(w,bypass(1:log2(m))),bypass(log2(m))||ordertest);
            
            % router for right-side fft
            right_inputs=right_inputs(index+1);
            
            % do right-side fft
            right_outputs=int16(zeros(m,n));
            parfor j=1:m
                right_outputs(j,:)=rfft(right_inputs(j,:),bypass(log2(m)+1:end),ordertest);
            end;
            
            % if left-side fft is bypassed partially, for ordertest,
            % output fft index need to be reordered
            if ordertest&&~bypass(log2(m))
                result=testorder_reorder(right_outputs,m,n,bypass);
                result=result(:);
            else
                result=right_outputs(:);
            end;
        end;
    end
fft_func=@fftn;
end
