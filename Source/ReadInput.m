% Read Input File %
function [dm] = ReadInputFile(file_name)
file_name = 'C:\Users\jyw0314.MIDASIT\Desktop\working\input_file\one_elem_linear.txt';

fid = fopen(file_name);

start_flag = false;
%%%%% what is dm ??
dm = 1.; %% must check %% 

while 1
  % READLINE
  tline = fgetl(fid);
  
  if (length(tline) == 0)
    continue;
  endif
  
  if tline == 'STARTINPUT'
    start_flag = true;
    break;
  endif
end

if start_flag
  while 1
    tline = fgetl(fid);
  
    if (length(tline) == 0)
      continue;
    endif
  
    switch tline
      case 'ENDINPUT'
        break;
      %%%%% PROPERTY %%%%%
      case 'PROPERTIES'
        prop_map = ReadBlock(fid,5);
      %%%%% GEOMETRY %%%%%
      case 'NODE'
        node_map = ReadBlock(fid,4);
      case 'HEXAELEMENT'
        hexa_map = ReadBlock(fid,10);
      %%%%% BOUNDARY CONDITION %%%%%
      case 'FIXED'
        fixed_map = ReadBlock(fid,2);
      case 'POINTLOAD'
        pload_map = ReadBlock(fid,4);
      otherwise
        continue;
    endswitch
  endwhile
endif

fclose(fid);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [map] = ReadBlock(fid,line_size)
  
  map = MapCreateEmpty();
  while 1
    tline = fgetl(fid);

    [c,mat] = strsplit(tline,{' ',','});

    if c(1){1} == 'ENDBLOCK'
      break;
    endif

    val = cellfun(@str2num,c);

    
    if(size(val,2) != line_size)
      error("Wrong Input PROPERITES");
    endif
    
    map = MapPutValue(map,val(1),val(2:line_size));
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function is_empty = IsEmptyLine(tline)
  if (length(tline) = 0)
    is_empty = true;
  else
    is_empty = false;
  endif
end