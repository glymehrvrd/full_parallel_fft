function [fft_func]=generate_fft_float(lfft,m,index,w,rfft,n)
    function [result]=fftn(data)
        left_outputs=zeros(n,m);
        for i=1:n
            [left_outputs(i,:)]=lfft(data(i:n:end));
        end;
        left_outputs=left_outputs.';
        
        right_inputs=left_outputs.*w;
        
        right_inputs=right_inputs(index+1);
        
        right_outputs=zeros(m,n);
        for j=1:m
            [right_outputs(j,:)]=rfft(right_inputs(j,:));
        end;
        result=right_outputs(:);
    end
    fft_func=@fftn;
end
