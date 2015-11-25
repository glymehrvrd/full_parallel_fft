function sysgen_add_components(this_block,varargin)
    nVarargs = length(varargin);
    for i=1:nVarargs
        switch varargin{i}
            case 'mul'
                add_multiplier(this_block);
            case 'base'
                add_base_components(this_block);
            case 'lib'
                add_library_components(this_block);
        end;
    end;

function add_multiplier(this_block)
  this_block.addFile('../lyon_multiplier/partial_product.vhd');
  this_block.addFile('../lyon_multiplier/partial_product_last.vhd');
  this_block.addFile('../lyon_multiplier/lyon_multiplier.vhd');
  this_block.addFile('../lyon_multiplier/complex_multiplier.vhd');
return;

function add_base_components(this_block)
  this_block.addFile('../base_components/adder_bit1.vhd');
  this_block.addFile('../base_components/adder_half_bit1.vhd');
  this_block.addFile('../base_components/Dff_reg1.vhd');
  this_block.addFile('../base_components/Dff_regN.vhd');
  this_block.addFile('../base_components/Dff_regN_Nout.vhd');
  this_block.addFile('../base_components/Dff_preload_reg1.vhd');
  this_block.addFile('../base_components/Dff_preload_reg1_init_1.vhd')
  this_block.addFile('../base_components/mux_in2.vhd');
  this_block.addFile('../base_components/shifter.vhd');
  this_block.addFile('../base_components/multiplier_mul1.vhd');
  this_block.addFile('../base_components/multiplier_mulminusj.vhd');
return;
 
function add_library_components(this_block)
    this_block.addFile('../base_components/32nm/HADDX1_LVT.vhd');
    this_block.addFile('../base_components/32nm/FADDX1_LVT.vhd');
    this_block.addFile('../base_components/32nm/DFFX1_LVT.vhd');
    this_block.addFile('../base_components/32nm/DFFSSRX1_LVT.vhd');
    this_block.addFile('../base_components/32nm/MUX21X1_LVT.vhd');
return;