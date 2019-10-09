function printBusInfo(busName)
%print_trialdata_bus.m

types = {'double', 'single', 'int8', 'uint8', 'int16', 'uint16', ...
    'int32', 'uint32', 'char', 'logical'};


b= eval( [busName '.Elements' ] );
for ne = 1:numel(b)
    disp(sprintf('%02i: Length(Name):%2i, Name: "%s"', ne, numel(b(ne).Name), b(ne).Name));
    disp(sprintf('    Length(Unit):%2i, Unit: "%s"', numel(b(ne).Unit), b(ne).Unit));
    dtid = find(strcmp(types, b(ne).DataType));
    disp(sprintf('    DataType ID : %i, DataType: "%s"', dtid, b(ne).DataType));
    disp(sprintf('    Num dims    : %i, Size: [ %i ]', numel(b(ne).Dimensions), b(ne).Dimensions));
end



% below is from 'writeSerlializeBusCode'
% function id = getDataTypeIdFromName(name)
%     types = {'double', 'single', 'int8', 'uint8', 'int16', 'uint16', ...
%         'int32', 'uint32', 'char', 'logical'};
%     [tf, which] = ismember(name, types);
%     assert(tf, 'Unsupported data type %s', name);
%     id = which - 1;
% end