# Time Management Feature

This directory contains the comprehensive time management system for the HR Connect application.

## Purpose

The time management feature enables:
- Leave request creation and approval
- Overtime/undertime tracking
- Remote work request processing
- Team schedule visualization
- Approval workflows

## Key Components

- Leave types (emergency, personal, sick, vacation, etc.)
- Overtime and remote work interfaces
- Approval and escalation workflows
- Configurable grace periods and limits
- Team calendar and schedule management

## Technical Approach

This feature implements:
- Leave and request management using Clean Architecture
- Offline-first data persistence with Flutter Data and Drift
- Approval workflows and business rules in the domain layer
- Riverpod for state management in the presentation layer 