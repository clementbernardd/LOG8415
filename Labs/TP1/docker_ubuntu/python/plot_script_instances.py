import json
import matplotlib.pyplot as plt
from datetime import datetime
import os
import fire
import numpy as np
from math import sqrt
import pandas as pd



class PlottingInstances(object):
    """Class that will plot the metrics for the instances."""
    def __init__(self, path: str):
        """
        Args :
            path (str) : the path to the metrics of the clusters
        """
        self.origin_path = path
        self.path = os.path.join(path, 'instances')
        self.metrics = os.listdir(self.path)

    def open(self, path: str):
        """Open a file and convert it to usable data."""
        with open(path) as f:
            data = json.load(f)
        data_values = data['Datapoints']
        data_values.sort(key=lambda x: x["Timestamp"])
        X = [datetime.strptime(x['Timestamp'], "%Y-%m-%dT%H:%M:%SZ") for x in data_values]
        Y = [x['Sum'] for x in data_values]
        return {'time': X, 'metric': Y}


    def plot_table(self, current_metric, metric_name):
        """Plot the current metric in a table."""
        if 'cluster_2' not in current_metric or 'cluster_1' not in current_metric or \
                len(current_metric['cluster_1']) == 0 or len(current_metric['cluster_2']) == 0 :
            return None
        column_1 = list(current_metric['cluster_1'].values())
        column_2 = list(current_metric['cluster_2'].values())

        column_1.append(np.mean(column_1))
        column_2.append(np.mean(column_2))

        data = {'cluster_1': column_1, 'cluster_2': column_2}

        index = [f'Instance {i}' for i in range(len(column_1) -1 )]
        index.append('Mean')
        new_data = pd.DataFrame(data, index = index )
        print(f"METRIC : {metric_name} : \n {new_data}")
        return new_data.iloc[-1,:].values


    def _plot(self, data):
        all_data = {}
        for i, (metric_name, value) in enumerate(data.items()):
            current_metric = {}
            for j, (cluster, subvalue) in enumerate(value.items()):
                current_cluster = {}
                for k, (instance_id, output) in enumerate(subvalue.items()):
                    avg = np.mean(output['metric'])
                    current_cluster[instance_id] = avg
                current_metric[cluster] = current_cluster
                val = self.plot_table(current_metric, metric_name)
            if val is not None:
                all_data[metric_name] = val
        self.plot_hist(all_data)


    def plot_hist(self, data):
        """Do the plotting process."""
        colors = ['r', 'b']
        N = int(sqrt(len(data)))
        figure, ax = plt.subplots(figsize=(12, 8), nrows=N, ncols=N + 1)
        ax = np.array(ax)
        labels = ['Cluster 1', 'Cluster 2']
        for i, (metric_name, value) in enumerate(data.items()):
            ax.flatten()[i].set_xticks([0,1])
            ax.flatten()[i].set_xticklabels(labels)
            ax.flatten()[i].set_ylabel(metric_name)
            ax.flatten()[i].bar(range(len(value)), value, color=colors)
            ax.flatten()[i].grid(True)
        figure.suptitle("EC2 instances metrics")
        plt.tight_layout()
        plt.show()
        figure.savefig(os.path.join(self.origin_path, 'figures', 'instances_figure.png'))

    def _plot_metric(self):
        all_data = {}
        for metric in self.metrics:
            ids = {x:  os.listdir(os.path.join(self.path, metric, x)) for x in ['cluster_1', 'cluster_2']}
            data = {}
            to_plot = False
            for cluster, instance_ids in ids.items():
                cluster_data = {}
                for instance in instance_ids:
                    value = self.open(path=os.path.join(self.path, metric, cluster, instance))
                    if value['metric'] != len(value['metric']) * [0.0] and len(value['metric']) > 0:
                        cluster_data[instance] = value
                        to_plot = True
                data[cluster] = cluster_data
            if to_plot:
                all_data[metric] = data
        self._plot(all_data)


    def plot_instances(self):
        """Plot the instance metrics"""
        self._plot_metric()


if __name__ == '__main__':
    fire.Fire(PlottingInstances)
