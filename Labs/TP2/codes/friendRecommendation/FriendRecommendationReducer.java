import java.io.IOException;
import java.util.*;
import java.util.HashMap;

import java.io.IOException;
import java.util.*;
import java.util.HashMap;
import java.util.Map.Entry;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.*;



public class FriendRecommendationReducer extends MapReduceBase implements Reducer<Text, FriendDegreeWritable, Text, Text> {

        public void reduce(Text key, Iterator<FriendDegreeWritable> values, OutputCollector<Text,Text> output, Reporter reporter) throws IOException {
                HashMap<String, Integer> mutualFriendsCount = new HashMap<String, Integer>();
                while (values.hasNext()) {
                        FriendDegreeWritable value = (FriendDegreeWritable) values.next();
                        String currentFriend = value.getFriend();

                // if the current user is already a friend we affect -1 (in order to remove it later)
                if (value.getDegree() == 1) mutualFriendsCount.put(currentFriend, -1);
                else {
                // if there is already the current user in the list and he is not a direct friend we increment the number of mutual friends
                        if(mutualFriendsCount.containsKey(currentFriend)) {
                                if (mutualFriendsCount.get(currentFriend) != -1) mutualFriendsCount.put(currentFriend, mutualFriendsCount.get(currentFriend) + 1);
                        }
                        else mutualFriendsCount.put(currentFriend, 1);
                }
                }

                MutualFriendComparator comparator = new MutualFriendComparator(mutualFriendsCount);
                TreeMap<String, Integer> sortedMutualFriends = new TreeMap<String, Integer>(comparator);

                for (Entry<String, Integer> pair: mutualFriendsCount.entrySet()) {
                        if (!pair.getValue().equals(-1)) {
                                sortedMutualFriends.put(pair.getKey(), pair.getValue());
                        }
                }

                String outputValue = "";
                int count = 10;
                if (sortedMutualFriends.size() < count) count = sortedMutualFriends.size();

                Iterator<String> iterator = sortedMutualFriends.keySet().iterator();
                for (int i = 0 ; i < count ; i++) {
                        String friendToAdd = iterator.next();
                        outputValue += friendToAdd;
                        if (i < count - 1) outputValue += ",";
                }
                output.collect(key, new Text(outputValue));

        }

        class MutualFriendComparator implements Comparator<String> {

                HashMap<String, Integer> base;
                public MutualFriendComparator(HashMap<String, Integer> base){
                        this.base = base;
                }

                @Override
                public int compare(String a , String b) {
                        // Get by decreasing number of mutual friends
                        if (base.get(a) > base.get(b)) return -1;
                        else if (base.get(a) < base.get(b)) return 1;
                        // If equal number of mutual friends get by increasing number of userID
                        else {
                                if(Integer.parseInt(a) > Integer.parseInt(b)) return 1;
                                else return -1;
                        }

                }

        }
}