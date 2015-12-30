function [fft_func]=generate_fft(lfft,m,index,w,rfft,n)
    w=int16(w.*2^14);
    function [result,eachclass]=fftn(data,bypass)

        if nargin==1
            bypass=zeros(1,log2(m*n));
        end;

        left_outputs=int16(zeros(n,m));
        for i=1:n
            [left_outputs(i,:),clz]=lfft(data(i:n:end),bypass(1:log2(m)));
            if i==1
                classleft=clz;
            else
                classleft=combinecell(classleft,clz);
            end;
        end;
        left_outputs=left_outputs.';
        
        right_inputs=complexmul(left_outputs,w,bypass(log2(m)));
        
        right_inputs=right_inputs(index+1);
        
        right_outputs=int16(zeros(m,n));
        for j=1:m
            [right_outputs(j,:),clz]=rfft(right_inputs(j,:),bypass(log2(m)+1:end));
            if j==1
                classright=clz;
            else
                classright=combinecell(classright,clz);
            end;
        end;
        eachclass=[classleft classright];
        result=right_outputs(:);
    end
    fft_func=@fftn;
end
