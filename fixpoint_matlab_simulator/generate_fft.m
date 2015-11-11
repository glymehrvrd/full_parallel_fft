function [fft_func]=generate_fft(lfft,m,index,w,rfft,n)
    w=reshape(w,m,n);
    w=int16(w*2^14);
    function [result]=fftn(data)
        for i=1:n
            left_outputs(i,:)=lfft(data(i:n:end));
        end;
        global stage;
        left_outputs=left_outputs.';
        stage=left_outputs;
        
        right_inputs=complexmul(left_outputs,w);
        
        global mmul;
        mmul=right_inputs;
        right_inputs=right_inputs(index+1);

        for j=1:m
            right_outputs(j,:)=rfft(right_inputs(j,:));
        end;
        result=right_outputs(:);
    end
    fft_func=@fftn;
end
