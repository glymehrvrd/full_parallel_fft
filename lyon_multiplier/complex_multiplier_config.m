
function complex_multiplier_config(this_block)

  % Revision History:
  %
  %   26-Oct-2015  (10:01 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     d:\dell\Documents\ISE Projects\fft\lyon_multiplier\complex_multiplier.vhd
  %
  %

  this_block.setTopLevelLanguage('VHDL');

  this_block.setEntityName('complex_multiplier');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
  this_block.tagAsCombinational;

  this_block.addSimulinkInport('rst');
  this_block.addSimulinkInport('ctrl_delay');
  this_block.addSimulinkInport('data_re_in');
  this_block.addSimulinkInport('data_im_in');

  this_block.addSimulinkOutport('product_re_out');
  this_block.addSimulinkOutport('product_im_out');

  product_re_out_port = this_block.port('product_re_out');
  product_re_out_port.setType('UFix_1_0');
  product_re_out_port.useHDLVector(false);
  product_im_out_port = this_block.port('product_im_out');
  product_im_out_port.setType('UFix_1_0');
  product_im_out_port.useHDLVector(false);

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('rst').width ~= 1);
      this_block.setError('Input data type for port "rst" must have width=1.');
    end

    this_block.port('rst').useHDLVector(false);

    if (this_block.port('ctrl_delay').width ~= 16);
      this_block.setError('Input data type for port "ctrl_delay" must have width=16.');
    end

    if (this_block.port('data_re_in').width ~= 1);
      this_block.setError('Input data type for port "data_re_in" must have width=1.');
    end

    this_block.port('data_re_in').useHDLVector(false);

    if (this_block.port('data_im_in').width ~= 1);
      this_block.setError('Input data type for port "data_im_in" must have width=1.');
    end

    this_block.port('data_im_in').useHDLVector(false);

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

  % (!) Custimize the following generic settings as appropriate. If any settings depend
  %      on input types, make the settings in the "inputTypesKnown" code block.
  %      The addGeneric function takes  3 parameters, generic name, type and constant value.
  %      Supported types are boolean, real, integer and string.
  this_block.addGeneric('re_multiplicator','INTEGER','-11585');
  this_block.addGeneric('im_multiplicator','INTEGER','-11585');
  this_block.addGeneric('ctrl_start','INTEGER','0');

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
  this_block.addFile('Dff_1.vhd');
  this_block.addFile('Dff_preload_1.vhd');
  this_block.addFile('Dff_preload_1_init_1.vhd')
  this_block.addFile('mux_in2.vhd');
  this_block.addFile('partial_product.vhd');
  this_block.addFile('partial_product_last.vhd');
  this_block.addFile('lyon_multiplier.vhd');
  this_block.addFile('complex_multiplier.vhd');

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

