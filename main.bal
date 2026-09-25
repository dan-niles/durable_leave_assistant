import ballerina/http;
import ballerina/workflow;
import ballerina/workflow.management;
import ballerinax/amp as _;

service /leave\-assistant on new http:Listener(9090) {

    resource function post requests(@http:Payload LeaveRequest request) returns RequestRef|error {
        string instanceId = check leaveAssistantAgent.run(string `Employee ${request.employeeId}: ${request.message}`);
        return {instanceId};
    }

    resource function get requests/[string instanceId]() returns RequestStatus|error {
        string|error answer = leaveAssistantAgent.getResult(instanceId);
        if answer is workflow:AgentBusyError {
            return {status: "in progress"};
        }
        return {status: "completed", answer: check answer};
    }

    resource function get requests/[string instanceId]/approvals() returns management:ReviewActivitySummary[]|error {
        management:ReviewActivitySummary[] approvals = check management:listPendingReviewActivities(instanceId);
        return approvals;
    }

    resource function post approvals/[string taskId](@http:Header {name: "x-user-role"} string role,
            @http:Payload management:ReviewDecision decision) returns error? {
        check management:completeReviewActivity(taskId, decision, callerRoles = [role]);
    }
}
