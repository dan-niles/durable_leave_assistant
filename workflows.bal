import ballerina/workflow;

final workflow:DurableAgent leaveAssistantAgent = check new ({
    systemPrompt: {
        role: string `Leave Assistant`,
        instructions: string `You handle employee leave requests.

1. Call getLeaveBalance for the employee.
2. If the balance is not enough, call notifyEmployee to explain why, and stop.
3. Otherwise call bookLeave. A manager must approve it first, so it may take a while to return.
4. When bookLeave returns, call notifyEmployee with the booking ID. If the manager rejected the booking, call notifyEmployee to say so, including the manager's feedback.
5. Finish with a one-line summary of the outcome.`
    },
    model: leaveAssistantModel,
    tools: [getLeaveBalance],
    activities: [
        {
            activity: bookLeave,
            description: "Books leave in the HR system. A manager must approve the booking before it runs.",
            approvalPolicy: {userRoles: "manager", title: "Approve leave request"}
        },
        {activity: notifyEmployee, description: "Sends a notification email to the employee."}
    ]
});
