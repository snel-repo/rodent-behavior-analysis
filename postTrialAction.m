classdef (Enumeration) postTrialAction < Simulink.IntEnumType
    enumeration
        DISABLED(0)
        TIMEOUT(1)
        REWARD(2)
    end
    methods (Static = true)
        function retVal = addClassNameToEnumNames()
            retVal = true;
        end
    end
end