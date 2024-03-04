
# import libraries
import matplotlib.pyplot as plt
import numpy as np

import matplotlib as mpl

# Specificy plot parameters
mpl.rcParams.update(
    {"font.size": 20, "text.color": "white", "font.family": "Times New Roman"}
)
plt.style.use("default")

# Generate Data
numb_data_points = 53
pre = np.random.uniform(low=0, high=55, size=numb_data_points)
post = np.random.uniform(low=75, high=100, size=numb_data_points)
data = [pre, post]
post_minus_pre_diff = [post - pre]

data_labels = [
    "Pre\nReproRehab",
    "Post\nReproRehab",
]

color_codes = [[0.1373, 0.3255, 0.4980], [0.5961, 0.3098, 0.8706]]  # Pre, Post
diff_color = [[0.9686, 0.4039, 0]]

# Create Figure
fig = plt.figure()
shapeRowVal = 1
shapeColVal = 3

ax_pre_post = plt.subplot2grid(shape=(shapeRowVal, shapeColVal), loc=(0, 0), colspan=2)
ax_diff = plt.subplot2grid(shape=(shapeRowVal, shapeColVal), loc=(0, 2), colspan=2)


# Create box plots
box_plot_width = 0.75
box_plot_width_diff = 0.45

b_plot_diff = ax_diff.boxplot(
    x=post_minus_pre_diff,
    widths=box_plot_width_diff,
    patch_artist=True,
)

b_plot_post_pre = ax_pre_post.boxplot(
    x=data,
    labels=data_labels,
    widths=box_plot_width,
    patch_artist=True,
)


# Adjust boxplot colors
def configure_box_plot_style(box_plot, face_colors):
    for patch, color_code, medians in zip(
        box_plot["boxes"], face_colors, box_plot["medians"]
    ):
        patch.set_facecolor(color_code)
        patch.set_alpha(0.5)
        medians.set_color(color_code)


configure_box_plot_style(b_plot_post_pre, color_codes)
configure_box_plot_style(b_plot_diff, diff_color)


# Create Scatter plots
def plot_jittered_scatter_points(ax, y_data, jitter_width, colors):
    for idx, y_data in enumerate(y_data):
        x_values = np.ones(len(y_data)) * (idx + 1) + np.random.uniform(
            -jitter_width, jitter_width, len(y_data)
        )
        ax.scatter(
            x_values,
            y_data,
            color=colors[idx],
            edgecolors="black",
            linewidths=1.75,
            s=scatter_size,
            zorder=20,
        )

scatter_size = 25
jitter_width = box_plot_width / 3

plot_jittered_scatter_points(ax_pre_post, data, jitter_width, color_codes)
plot_jittered_scatter_points(ax_diff, post_minus_pre_diff, jitter_width, diff_color)


# Finalize figures
ax_pre_post.grid(alpha=0.5)
ax_pre_post.set_ylim(-2, 102)
ax_pre_post.spines[["top", "right"]].set_visible(False)
ax_pre_post.set_ylabel("Programming confidence (%)")

ax_diff.grid(alpha=0.5)
ax_diff.set_ylim(20, 95)
ax_diff.spines[["top", "right"]].set_visible(False)
ax_diff.set_ylabel("Improvement")
ax_diff.set_xticks([])

# change y labels
y_labels = [t._text for t in ax_diff.get_yticklabels()[1:-1]]
y_values = [v._y for v in ax_diff.get_yticklabels()]
ax_diff.set_yticks(ticks=y_values, labels=["Less"] + y_labels + ["More"])


fig.tight_layout()
plt.show()
