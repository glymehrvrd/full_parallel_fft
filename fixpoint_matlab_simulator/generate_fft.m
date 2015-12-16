function [fft_func]=generate_fft(lfft,m,index,w,rfft,n)
    w=int16(w.*2^14);
    function [result,eachclass,eachmul]=fftn(data)
        for i=1:n
            [left_outputs(i,:),clz]=lfft(data(i:n:end));
            if i==1
                classleft=clz;
            else
                classleft=combinecell(classleft,clz);
            end;
        end;
        left_outputs=left_outputs.';
        
        right_inputs=complexmul(left_outputs,w);
        
        right_inputs=right_inputs(index+1);
        
        classright=[];
        for j=1:m
            [right_outputs(j,:),clz]=rfft(right_inputs(j,:));
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
