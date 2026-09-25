enum LeaveType {
    ANNUAL = "annual",
    SICK = "sick"
}

type LeaveBalance record {|
    string employeeId;
    string name;
    int annual;
    int sick;
|};

type LeaveBooking record {|
    string bookingId;
    string employeeId;
    LeaveType leaveType;
    string startDate;
    int days;
|};

type LeaveRequest record {|
    string employeeId;
    string message;
|};

type RequestRef record {|
    string instanceId;
|};

type RequestStatus record {|
    string status;
    string? answer = ();
|};
