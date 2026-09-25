import ballerina/ai;
import ballerina/log;
import ballerina/uuid;
import ballerina/workflow;

final readonly & map<LeaveBalance> balances = {
    "E-3001": {employeeId: "E-3001", name: "Nimal Perera", annual: 12, sick: 5},
    "E-3002": {employeeId: "E-3002", name: "Ayesha Khan", annual: 3, sick: 2}
};

# Returns the remaining annual and sick leave days of an employee.
#
# + employeeId - The employee ID, for example "E-3001"
# + return - The employee's leave balance
@ai:AgentTool
isolated function getLeaveBalance(string employeeId) returns LeaveBalance|error {
    LeaveBalance? balance = balances[employeeId];
    if balance is () {
        return error(string `Unknown employee ${employeeId}`);
    }
    return balance;
}

# Books leave in the HR system. A manager must approve the booking before it runs.
#
# + employeeId - The employee ID
# + leaveType - The type of leave
# + startDate - The first day of leave, as YYYY-MM-DD
# + days - The number of leave days
# + return - The confirmed booking
@workflow:Activity
isolated function bookLeave(string employeeId, LeaveType leaveType, string startDate, int days) returns LeaveBooking|error {
    LeaveBooking booking = {bookingId: uuid:createType4AsString().substring(0, 8), employeeId, leaveType, startDate, days};
    log:printInfo("Leave booked in the HR system", bookingId = booking.bookingId, employeeId = employeeId,
            leaveType = leaveType, startDate = startDate, days = days);
    return booking;
}

# Sends a notification email to the employee.
#
# + employeeId - The employee ID
# + message - The message to send
# + return - An error if the email could not be sent
@workflow:Activity
isolated function notifyEmployee(string employeeId, string message) returns error? {
    log:printInfo("Email sent to employee", employeeId = employeeId, body = message);
}
