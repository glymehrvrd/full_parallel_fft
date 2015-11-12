
function fft_pt32_config(this_block)

  % Revision History:
  %
  %   28-Oct-2015  (21:50 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     d:\dell\Documents\ISE Projects\fft\fft\fft_pt32.vhd
  %
  %

  this_block.setTopLevelLanguage('VHDL');

  this_block.setEntityName('fft_pt32');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
  this_block.tagAsCombinational;

  this_block.addSimulinkInport('rst');
  this_block.addSimulinkInport('ctrl');
  this_block.addSimulinkInport('data_re_in');
  this_block.addSimulinkInport('data_im_in');

  this_block.addSimulinkOutport('data_re_out');
  this_block.addSimulinkOutport('data_im_out');

  data_re_out_port = this_block.port('data_re_out');
  data_re_out_port.setType('UFix_32_0');
  data_im_out_port = this_block.port('data_im_out');
  data_im_out_port.setType('UFix_32_0');

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('rst').width ~= 1);
      this_block.setError('Input data type for port "rst" must have width=1.');
    end

    this_block.port('rst').useHDLVector(false);

    if (this_block.port('ctrl').width ~= 1);
      this_block.setError('Input data type for port "ctrl" must have width=1.');
    end

    this_block.port('ctrl').useHDLVector(false);

    if (this_block.port('data_re_in').width ~= 32);
      this_block.setError('Input data type for port "data_re_in" must have width=32.');
    end

    if (this_block.port('data_im_in').width ~= 32);
      this_block.setError('Input data type for port "data_im_in" must have width=32.');
    end

  end  % if(inputTypesKnown)
  % -----------------------------

  % -----------------------------
   if (this_block.inputRatesKnown)
     setup_as_single_rate(this_block,'clk','ce')
   end  % if(inputRatesKnown)
  % -----------------------------

    % (!) Set the inout port rate to be the same as the first input 
    %     rate. Change the following code if this is untrue.
    uniqueInputRates = unique(this_block.getInputRates);


  % Add addtional source files as needed.
  %  |-------------
  %  | Add files in the order in which they should be compiled.
  %  | If two files "a.vhd" and "b.vhd" contain the entities
  %  | entity_a and entity_b, and entity_a contains a
  %  | component of type entity_b, the correct sequence of
  %  | addFile() calls would be:
  %  |    this_block.addFile('b.vhd');
  %  |    this_block.addFile('a.vhd');
  %  |-------------

  %    this_block.addFile('');
  %    this_block.addFile('');
  this_block.addFile('adder_half_bit1.vhd');
  this_block.addFile('adder_bit1.vhd');
  this_block.addFile('Dff_preload_1.vhd');
  this_block.addFile('Dff_preload_1_init_1.vhd');
  this_block.addFile('fft_pt2.vhd');
  this_block.addFile('fft_pt2_nodelay.vhd');
  this_block.addFile('fft_pt4.vhd');
  
  this_block.addFile('Dff_1.vhd');
  this_block.addFile('mux_in2.vhd');
  this_block.addFile('partial_product.vhd');
  this_block.addFile('partial_product_last.vhd');
  this_block.addFile('lyon_multiplier.vhd');
  this_block.addFile('complex_multiplier.vhd');
  
  this_block.addFile('Dff_N.vhd');
  this_block.addFile('shifter.vhd');
  this_block.addFile('fft_pt8.vhd');
  
  this_block.addFile('fft_pt32.vhd');

return;


% ------------------------------------------------------------

function setup_as_single_rate(block,clkname,cename) 
  inputRates = block.inputRates; 
  uniqueInputRates = unique(inputRates); 
  if (length(uniqueInputRates)==1 & uniqueInputRates(1)==Inf) 
    block.addError('The inputs to this block cannot all be constant.'); 
    return; 
  end 
  if (uniqueInputRates(end) == Inf) 
     hasConstantInput = true; 
     uniqueInputRates = uniqueInputRates(1:end-1); 
  end 
  if (length(uniqueInputRates) ~= 1) 
    block.addError('The inputs to this block must run at a single rate.'); 
    return; 
  end 
  theInputRate = uniqueInputRates(1); 
  for i = 1:block.numSimulinkOutports 
     block.outport(i).setRate(theInputRate); 
  end 
  block.addClkCEPair(clkname,cename,theInputRate); 
  return; 

% ------------------------------------------------------------

