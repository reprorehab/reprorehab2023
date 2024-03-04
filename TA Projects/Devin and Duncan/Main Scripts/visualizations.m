%% Visualizations - RR 2023-2024 TA project

clear();
clc();
close('all');
code_folder = ['/Users/duncan/Documents/GitHub/reprorehab2023_TA_project/' ...
  'TA Projects/Devin and Duncan'];
cd(code_folder);

%% Set up 

% simulate data 
N_STUDENTS = 53; 
pre_rr = unirnd(0, 55, [1, N_STUDENTS]);
post_rr = unirnd(75, 100, [1, N_STUDENTS]);
improvement_rr = post_rr - pre_rr; 

% colors
RGB_PRE = [0.1373 0.3255 0.4980];
RGB_POST = [0.5961 0.3098 0.8706];
RGB_IMPROVEMENT = [0.9686 0.4039 0];

% groups 
N_GROUPS = 2; 

%% Main Visual 

figure();
pre_post_ax = subplot(1, 3, 1:2);
for i_group = 1:N_GROUPS
  is_pre_group = i_group == 1; 
  is_post_group = i_group == 2; 
  if is_pre_group
    data = pre_rr; 
    color = RGB_PRE; 
  elseif is_post_group
    data = post_rr; 
    color = RGB_POST; 
  else 
    error('No group defined besides pre and post.\n');
  end
  box_with_data(pre_post_ax, i_group, data, color);
end
grid(pre_post_ax, 'on');
xticks(pre_post_ax, 1:2);
xticklabels(pre_post_ax, {'Pre-RR', 'Post-RR'});
ylabel(pre_post_ax, 'Programming Confidence');

%% Inset 
improvement_ax = subplot(1, 3, 3);
box_with_data(improvement_ax, 1, improvement_rr, RGB_IMPROVEMENT);
xticks(improvement_ax, []);
set(improvement_ax, ...
  'yticklabels', [{'Less'}; improvement_ax.YTickLabel(2:end-1); {'More'}]);
grid(improvement_ax, 'on');
ylabel(improvement_ax, 'Improvement');

%% Local functions 
function box_with_data(ax, x, y, color)
n = length(y); 
boxchart(ax, repelem(x, n), y, ...
  "BoxFaceColor", color, ...
  "MarkerStyle", 'none', ...
  'BoxFaceAlpha', 0.5);
hold(ax, 'on');
swarmchart(ax, ...
  repelem(x, n), y, ...
  'MarkerEdgeColor', 'k', ...
  'LineWidth', 2, ...
  'MarkerFaceColor', color, ...
  'xjitterwidth', 0.5);
end

function values = unirnd(min, max, sz)
values = min + (max - min) .* rand(sz);
end
