function PlotResults(targets,outputs,Name)

    errors=targets-outputs;

    RMSE=sqrt(mean(errors(:).^2));
    
    error_mean=mean(errors(:));
    error_std=std(errors(:));

    subplot(2,2,[1 2]);
    plot(targets,'k');
    hold on;
    plot(outputs,'r');
    legend('Target','Output');
    title(Name);

    subplot(2,2,3);
    plot(errors);
    legend('Error');
    title(['RMSE = ' num2str(RMSE)]);

    subplot(2,2,4);
    histfit(errors);
    title(['Error: mean = ' num2str(error_mean) ', std = ' num2str(error_std)]);

end