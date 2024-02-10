import numpy
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np


mpl.rcParams.update(
    {"font.size": 25, "text.color": "lavender", "font.family": "Palatino Linotype"}
)

numb_data_points = 25

y_1 = numpy.random.normal(28, 8, numb_data_points)  # undergrads
y_2 = numpy.random.normal(12, 5, numb_data_points)  # grad
y_3 = numpy.random.normal(5, 3, numb_data_points)  # non tunured faculty
y_4 = numpy.random.normal(18, 12, numb_data_points)  # tenured faculty

data = [y_1, y_2, y_3, y_4]

data_labels = [
    "Undergrad\nStudents",
    "Graduate\nStudents",
    "Non-Tenured\nFaculty",
    "Tenured\nFaculty",
]

title = "Alcoholic beverages consumed in the past month"

y_label = "Number of drinks"

scatter_size = 200

box_plot_width = 0.75
fig_size = [12, 10]

axs = plt.subplot()

b_plot = plt.boxplot(
    x=data,
    labels=data_labels,
    widths=box_plot_width,
    patch_artist=True,
    showfliers=False,
)

color_codes = ["#376101", "#89ce00", "#e6308a", "#8f144e"]

for patch, color_code in zip(b_plot["boxes"], color_codes):
    patch.set_facecolor(color_code)

jitter_width = box_plot_width / 3

for idx, y_data in enumerate(data):
    x_values = np.ones(len(y_data)) * (idx + 1) + np.random.uniform(
        -jitter_width, jitter_width, len(y_data)
    )

    if idx == 3:
        for y_idx in range(len(y_data)):
            if y_data[y_idx] >= 13:
                split_marker = "D"
            else:
                split_marker = "o"

            axs.scatter(
                x_values[y_idx],
                y_data[y_idx],
                color=color_codes[idx],
                edgecolors="black",
                linewidths=1.75,
                s=scatter_size,
                zorder=20,
                marker=split_marker,
            )

    else:
        axs.scatter(
            x_values,
            y_data,
            color=color_codes[idx],
            edgecolors="black",
            linewidths=1.75,
            s=scatter_size,
            zorder=20,
        )

axs.scatter(
    [],
    [],
    marker="D",
    color=color_codes[3],
    s=scatter_size,
    label="Doesn't show up on monday",
)

plt.grid(alpha=0.5)
plt.legend()
axs.set_title(title)
axs.set_ylabel(y_label)
fig = plt.gcf()
fig.set_size_inches(fig_size)

