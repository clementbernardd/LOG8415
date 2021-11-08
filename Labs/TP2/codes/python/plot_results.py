import fire
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


class PlotObject(object):
    """Class to plot the time outputs for the different comparisons."""
    def __init__(
            self,
            path_to_output: str,
    ):
        """

        :param path_to_output: path to the results.
        """
        self.path_to_output = path_to_output

    def _read_txt(self, path: str):
        """Read a txt file."""
        with open(path) as f:
            output = f.readlines()
            # Remove the '\n'
            return np.mean([float(x[:-1]) for x in output])

    def _get_all_times(self, path: str):
        """Return all the average time for all the datasets."""
        dataset_times = {}
        for file in os.listdir(path):
            current_path = os.path.join(path, file)
            dataset_times[file]=self._read_txt(current_path)
        return dataset_times

    def _get_scores_by_method(self, methods=['hadoop', 'linux']):
        """Return the average time for each method for all the datasets."""
        method_times = {}
        for method in methods:
            path = os.path.join(self.path_to_output, method, 'time')
            all_times = self._get_all_times(path)
            method_times[method] = all_times
        return method_times


    def _plot_df(self, method_times: dict):
        """Print in a dataframe the results."""
        methods = list(method_times.keys())
        dataset_names = [f'dataset{i}.txt' for i in range(10)]
        df = {m : [method_times[m][k] for k in dataset_names] for i,m in enumerate(methods)}
        # Add the mean
        for m in df :
            df[m].append(np.mean(df[m]))
        dataset_names.append('Mean')
        df = pd.DataFrame(df, index = dataset_names)
        print(df)

    def _plot_comparison(self, method_times: dict, has_spark = False):
        """Plot the comparison for the given methods."""
        figure, ax = plt.subplots(figsize=(12, 8), nrows=2, ncols=1)
        # Plot the bar chart for each dataset
        ax1 = ax[0]
        ax2 = ax[1]
        methods = list(method_times.keys())
        dataset_names = [f'dataset{i}.txt' for i in range(10)]
        data1 = [method_times[methods[0]][k] for k in dataset_names]
        data2 = [method_times[methods[1]][k] for k in dataset_names]
        width = 0.3
        ax1.bar(np.arange(len(data1)), data1, width=width, color='r', label=methods[0])
        ax1.bar(np.arange(len(data2)) + width, data2, width=width, color='g' if has_spark else 'b', label=methods[1])
        ax1.tick_params(axis='x', labelrotation=10)
        ax1.set_xticks(np.arange(10))
        ax1.set_yscale('log')
        ax1.set_ylabel('User time')
        ax1.set_xlabel('Dataset')
        ax1.legend()
        ax1.grid(True)
        ax1.set_xticklabels(dataset_names)
        ax1.set_title(f'Comparison per dataset for {methods[0]} and {methods[1]}', fontsize=12)
        # Plot bar chart for the average of the average
        data = [np.mean(data1), np.mean(data2)]
        colors=['r', 'g'] if has_spark else ['r', 'b']
        ax2.set_xticks([0, 1])
        ax2.set_xticklabels(methods)
        ax2.set_ylabel('Average User time')
        ax2.bar(range(len(data)), data, width = 0.3,  color=colors)
        ax2.grid(True)
        ax2.set_yscale('log')
        ax2.grid(True)
        ax2.set_xlabel('Methods')
        plt.show()


    def plot_hadoop_vs_linux(self):
        method_times = self._get_scores_by_method()
        self._plot_comparison(method_times)
        self._plot_df(method_times)

    def plot_hadoop_vs_spark(self):
        method_times = self._get_scores_by_method(methods=['hadoop', 'spark'])
        self._plot_comparison(method_times, has_spark=True)
        self._plot_df(method_times)



if __name__ == '__main__' :
    fire.Fire(PlotObject)