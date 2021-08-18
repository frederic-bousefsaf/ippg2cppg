function [means,diffs,meanDiff,CR,linFit] = BlandAltman(var1, var2, flag)

if nargin==2
    flag = 0;
end

means = var1;
diffs = var1-var2;

meanDiff = mean(diffs);
sdDiff = std(diffs);
CR = [meanDiff + 1.96 * sdDiff, meanDiff - 1.96 * sdDiff]; %%95% confidence range

linFit = polyfit(means,diffs,1); %%%work out the linear fit coefficients

%%%plot results unless flag is 0
if flag ~= 0
    plot(var1,diffs,'.')
    hold on
    ax = gca;
    if (ax.ColorOrderIndex > 2)
        ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
    else
        ax.ColorOrderIndex = 1;
    end
    if flag > 1
        plot([min(means) max(means)], ones(1,2).*CR(1),'--black','HandleVisibility','off','LineWidth',1); %%%plot the upper CR
        if (ax.ColorOrderIndex > 2)
            ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
        else
            ax.ColorOrderIndex = 1;
        end
        plot([min(means) max(means)], ones(1,2).*CR(2),'--black','HandleVisibility','off','LineWidth',1); %%%plot the lower CR
        if (ax.ColorOrderIndex > 2)
            ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
        else
            ax.ColorOrderIndex = 1;
        end
        plot([min(means) max(means)], ones(1,2).*meanDiff,'-.black','HandleVisibility','off','LineWidth',1); %%%plot the mean
    end
    if flag > 2
        if (ax.ColorOrderIndex > 2)
            ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
        else
            ax.ColorOrderIndex = 1;
        end
        plot(means, means.*linFit(1)+linFit(2),'--','HandleVisibility','off'); %%%plot the linear fit
    end
end

end