
function fft_pt8_config(this_block)

  % Revision History:
  %
  %   06-Nov-2015  (18:48 hours):
  %     Original code was machine generated by Xilinx's System Generator after parsing
  %     d:\dell\Documents\ISE Projects\fft\fft\fft_pt8.vhd
  %
  %

  this_block.setTopLevelLanguage('VHDL');

  this_block.setEntityName('fft_pt8');

  % System Generator has to assume that your entity  has a combinational feed through; 
  %   if it  doesn't, then comment out the following line:
  this_block.tagAsCombinational;

  this_block.addSimulinkInport('rst');
  this_block.addSimulinkInport('bypass');
  this_block.addSimulinkInport('ctrl_delay');
  this_block.addSimulinkInport('data_re_in');
  this_block.addSimulinkInport('data_im_in');

  this_block.addSimulinkOutport('tmp_first_stage_re_out');
  this_block.addSimulinkOutport('tmp_first_stage_im_out');
  this_block.addSimulinkOutport('tmp_mul_re_out');
  this_block.addSimulinkOutport('tmp_mul_im_out');
  this_block.addSimulinkOutport('data_re_out');
  this_block.addSimulinkOutport('data_im_out');

  tmp_first_stage_re_out_port = this_block.port('tmp_first_stage_re_out');
  tmp_first_stage_re_out_port.setType('UFix_8_0');
  tmp_first_stage_im_out_port = this_block.port('tmp_first_stage_im_out');
  tmp_first_stage_im_out_port.setType('UFix_8_0');
  tmp_mul_re_out_port = this_block.port('tmp_mul_re_out');
  tmp_mul_re_out_port.setType('UFix_8_0');
  tmp_mul_im_out_port = this_block.port('tmp_mul_im_out');
  tmp_mul_im_out_port.setType('UFix_8_0');
  data_re_out_port = this_block.port('data_re_out');
  data_re_out_port.setType('UFix_8_0');
  data_im_out_port = this_block.port('data_im_out');
  data_im_out_port.setType('UFix_8_0');

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    if (this_block.port('rst').width ~= 1);
      this_block.setError('Input data type for port "rst" must have width=1.');
    end

    this_block.port('rst').useHDLVector(false);

    if (this_block.port('bypass').width ~= 3);
      this_block.setError('Input data type for port "bypass" must have width=1.');
    end

    if (this_block.port('ctrl_delay').width ~= 16);
      this_block.setError('Input data type for port "ctrl_delay" must have width=1.');
    end

    if (this_block.port('data_re_in').width ~= 8);
      this_block.setError('Input data type for port "data_re_in" must have width=8.');
    end

    if (this_block.port('data_im_in').width ~= 8);
      this_block.setError('Input data type for port "data_im_in" must have width=8.');
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

  % (!) Custimize the following generic settings as appropriate. If any settings depend
  %      on input types, make the settings in the "inputTypesKnown" code block.
  %      The addGeneric function takes  3 parameters, generic name, type and constant value.
  %      Supported types are boolean, real, integer and string.
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

  sysgen_add_components(this_block,'lib','base','mul');
  
  this_block.addFile('fft_pt2.vhd');
  this_block.addFile('fft_pt4.vhd');
  
  this_block.addFile('fft_pt8.vhd');

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

