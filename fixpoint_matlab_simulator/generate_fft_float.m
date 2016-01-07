function [fft_func]=generate_fft_float(lfft,m,index,w,rfft,n)
    function [result,eachclass]=fftn(data)
        left_outputs=zeros(n,m);
        for i=1:n
            [left_outputs(i,:),clz]=lfft(data(i:n:end));
            if i==1
                classleft=clz;
            else
                classleft=combinecell(classleft,clz);
            end;
        end;
        left_outputs=left_outputs.';
        
        right_inputs=left_outputs.*w;
        
        right_inputs=right_inputs(index+1);
        
        classright=[];
        right_outputs=zeros(m,n);
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
