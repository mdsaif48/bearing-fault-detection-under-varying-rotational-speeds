RMS_healthy = [dataStruct(strcmp({dataStruct.health}, 'Healthy')).RMS];
RMS_inner   = [dataStruct(strcmp({dataStruct.health}, 'InnerFault')).RMS];
RMS_outer   = [dataStruct(strcmp({dataStruct.health}, 'OuterFault')).RMS];

figure;
boxplot([RMS_healthy, RMS_inner, RMS_outer], ...
        [repmat({'Healthy'},1,length(RMS_healthy)), ...
         repmat({'InnerFault'},1,length(RMS_inner)), ...
         repmat({'OuterFault'},1,length(RMS_outer))]);
ylabel('RMS Value');
title('Comparison of RMS Across Health Conditions');
