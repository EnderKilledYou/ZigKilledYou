const std = @import("std");

pub const TaskData  = struct {
        data: u8
};

pub const TaskSingles = struct {
    next: ?*TaskSingles = null,
    data: ?*TaskData = null,
};

pub fn KooshTask() type {
    return struct {
     root: ?*TaskSingles = null,
     current: ?*TaskSingles = null,
     end: ?*TaskSingles = null,
     mutex: std.Thread.Mutex = .{},
     count: u16 =0,

     pub const Self = @This();

     pub fn init() Self {
     return Self {

        };
     }

    fn increment_tasks_ran(self: *Self) void{
        self.count +=1;
    }

    // The function that runs on repeat
    fn task_runner(self: *Self,  data : ?TaskData) !void {
        std.debug.print("All your {} are belong to us.\n", .{data});
        self.increment_tasks_ran();
        //brrrrrrr
    }


    // what manages each task_runner getting it data and waiting
    // a consumer
    fn task_manager(self: *Self)  !void {


        const data = self.read_next_task() catch |x| {
                        std.debug.print("Error getting next task:  {} .\n", .{x});
        };
        self.task_runner(data) catch |x| {
                        std.debug.print("Error getting task:  {} {} .\n", .{x, data});
        };
    }

    pub fn add_task(self: *Self,data : ?*TaskData) !void {
        self.mutex.lock();
        defer self.mutex.unlock();
        if ( self.root == null){
            self.root = data;
            self.current = data;
            self.end = data;
            return;
        }
        self.end.next = data;
        self.end = data;
        // lock TaskSingles,
        // defer unlock TaskSingles
        // append data to end of list

    }

    fn read_next_task(self: *Self) !?*TaskData {
            self.mutex.lock();
            defer self.mutex.unlock();
            if (self.current == null)
            {
                return null;
            }
            const tmp = self.current;
            self.current = self.current.next;
            return tmp;
        // lock TaskSingles,
        // defer unlock TaskSingles
        // check if current next is null
        // return null if empty
        // assign to tmp otherwise
        // increment current

    }

};
}
test "KooshTask add_task" {


}