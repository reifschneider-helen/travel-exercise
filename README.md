# SAP S4D437 – ABAP RESTful Application Programming Model (`travel-exercise`)

This repository contains my personal practice code, hands-on deliverables, and exercise implementations created while completing the **SAP S4D437: Building Apps with the ABAP RESTful Application Programming Model (RAP)** course.

---

## 🎯 Course & Repository Objectives

The objective of this repository is to master modern end-to-end application development on SAP S/4HANA and SAP BTP ABAP Environment using the **ABAP RESTful Application Programming Model (RAP)**. The implementation covers everything from basic BO architecture to draft handling, compositions, unmanaged behavior, business events, and extensibility.

---

## 📚 Curriculum & Units Covered

### 🔹 Unit 1: Explaining the ABAP RESTful Application Programming Model
- High-level architecture of RAP (Data Model, Behavior Definition, Behavior Implementation, Service Definition, Service Binding).
- CDS View entities, RAP BO concepts, and modern OData service publishing.

### 🔹 Unit 2: Working with Business Objects
- Defining RAP Business Objects with read/query capabilities.
- Implementing determinations, validations, dynamic feature control, and custom actions.

### 🔹 Unit 3: Adding Basic Operations (Update & Create)
- Enabling full CUD (Create, Update, Delete) operations in managed RAP scenarios.
- Early/late numbering techniques and field control setup.

### 🔹 Unit 4: Developing Draft-Enabled Services
- Implementing draft capabilities (`with draft`) to enable transactional state saving.
- Configuring `draft determine action Prepare` and active vs. draft instance lifecycle management.

### 🔹 Unit 5: Defining Compositions
- Building multi-level parent-child hierarchy models using composition associations (`composition of`).
- Managing transactional consistency across root and child entities.

### 🔹 Unit 6: Implementing Unmanaged Data Access
- Working with unmanaged behavior definitions for legacy code integration and custom save procedures.
- Implementing custom CUD buffer logic in Behavior Pools (`saver` classes).

### 🔹 Unit 7: Integrating Business Events
- Defining and triggering RAP Business Events for event-driven integration scenarios.
- Publishing events for consumption via SAP Event Mesh / Cloud Events.

### 🔹 Unit 8: Enabling and Using Extensibility
- Enhancing standard RAP BOs cleanly using BDEF extensions and CDS view extensions.
- Implementing extensibility contracts while adhering to Clean Core guidelines.

---

## 🛠️ Environment & Prerequisites

- **Development Environment:** ABAP Development Tools (ADT) in Eclipse
- **Target System:** SAP S/4HANA or SAP BTP ABAP Environment
- **Git Sync:** Syncing managed via **abapGit**
- **Demo Model:** SAP Flight Data Model (`/DMO/` objects) or course-specific training artifacts

---

## 📁 Repository Structure

```text
├── src/                  # ABAP & CDS source files
│   ├── DDLS/             # Data Definitions (CDS Views: Root, Composition, Projection)
│   ├── BDEF/             # Behavior Definitions (Managed, Unmanaged, Draft)
│   ├── CLAS/             # Behavior Implementation Classes (Behavior Pools)
│   └── SRVD/             # Service Definitions & Service Bindings
├── .gitignore            # Git ignore configuration for abapGit
└── README.md             # Repository documentation
```

---

## 📌 Usage & Disclaimer

This repository is maintained for personal learning, practice reference, and code history. All code implementations are custom deliverables written during training exercises.

*Referenced data models or standard SAP structures belong to SAP SE.*
