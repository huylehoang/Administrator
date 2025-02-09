# Administrator
1. The administrator can look through fetched users’ information in UsersView.
2. The administrator can scroll down to see more users’ information with 20 items per fetch.
3. Users’ information show immediately when the administrator launches the application for the second time.
4. Clicking on an item will navigate to the UserDetailsView.
5. Implement the unit tests for all components
6. Implement a simple automation test for this app

## Architecture
![swift-clean-architecture](https://github.com/user-attachments/assets/63b854ab-a94e-47f3-87fd-8b5d00664099)

### MVVM-C
- Model (Entity): represents as app data.
- View: handles the UI and user interactions.
- ViewModel (Presenter): mediates between the View and Model, notifies the View of changes and manages presentation logic, interact with UseCase layer.
- UseCase: contains business logic, manages app data and interacts with Service layer.
- Service: communicates with external systems, such as APIs, databases, or other services.
- Coordinator: handles app navigation.

## Test Coverage
- Using XCTest for unit testing.
- Coverage for Coordinators (100%).
- Coverage for Services (97%).
- Coverage for UseCases (100%).
- Coverage for ViewModels (100%).
- Coverage for Utilities (100%).
