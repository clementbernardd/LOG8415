import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;

import java.io.IOException;
import java.io.DataInput;
import java.io.DataOutput;

public class FriendDegreeWritable implements Writable {
    private Text friend;
    private IntWritable degree;

    public FriendDegreeWritable() {
        this.friend = new Text();
        this.degree = new IntWritable();
    }

    public FriendDegreeWritable(Text friend1, IntWritable degree) {
        this.friend = friend1;
        this.degree = degree;
    }

    @Override
    public void readFields(DataInput in) throws IOException {
        this.friend.readFields(in);
        this.degree.readFields(in);
    }

    @Override
    public void write(DataOutput out) throws IOException {
        friend.write(out);
        degree.write(out);
    }

    public int getDegree() {
        return degree.get();
    }

    public String getFriend() {
        return friend.toString();
    }
}