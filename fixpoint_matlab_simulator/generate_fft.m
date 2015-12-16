function [fft_func]=generate_fft(lfft,m,index,w,rfft,n)
    w=int16(w.*2^14);
    w=tobitarray(w);
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
        
        for i=1:size(left_outputs,1)
            for j=1:size(left_outputs,2)
                right_inputs{i,j}=complexmul(left_outputs{i,j},w{i,j});
            end;
        end;
        
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
