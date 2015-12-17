function [result,eachclass]=fft5(data)

    t51=complexadd(data(2),data(5));
    t52=complexadd(data(3),data(4));
    t53=complexsub(data(2),data(5));
    t54=complexsub(data(4),data(3));
    t55=complexadd(t51,t52);
    t56=complexsub(t51,t52);
    t57=complexadd(t53,t54);
    
    m51=complexadd(data(1),t55);

    m52=complex(bitshift(real(t55),-2),bitshift(imag(t55),-2));
    m52=complexadd(m52,t55);
    m52=complexsub(0,m52);

    m53=complex(mul(real(t56),18318),mul(imag(t56),18318));
    
    m54=complex(-mul(imag(t57),31164),mul(real(t57),31164));
    
    m55=complex(mul(imag(t54),25212),-mul(real(t54),25212));
    m55=complex(bitshift(real(m55),1),bitshift(imag(m55),1));
    
    m56=complex(mul(imag(t53),11904),-mul(real(t53),11904));

    s51=complexadd(m51,m52);
    s52=complexadd(s51,m53);
    s53=complexadd(m54,m55);
    s54=complexsub(s51,m53);
    s55=complexadd(m54,m56);

    x51=m51;
    x52=complexsub(s52,s53);
    x53=complexsub(s54,s55);
    x54=complexadd(s54,s55);
    x55=complexadd(s52,s53);

    result=[x51 x52 x53 x54 x55];
    eachclass={result(:)};
end