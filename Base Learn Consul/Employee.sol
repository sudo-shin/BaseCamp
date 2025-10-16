// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

interface IEmployee {
    function idNumber() external returns (uint);
    function managerId() external returns (uint);
}

interface ISalaried is IEmployee {
    function annualSalary() external returns (uint);
}

interface IHourly is IEmployee {
    function hourlyRate() external returns (uint);
}

interface ISalesPerson is IHourly {}

interface IEngineeringManager is ISalaried {}

interface IInheritanceSubmission {
    function salesPerson() external returns (address);
    function engineeringManager() external returns (address);
}

contract SalesPerson is ISalesPerson {
    function hourlyRate() external pure override returns (uint) {
        return 20;
    }

    function idNumber() external pure override returns (uint) {
        return 55555;
    }

    function managerId() external pure override returns (uint) {
        return 0;
    }
}

contract EngineeringManager is IEngineeringManager {
    function annualSalary() external pure override returns (uint) {
        return 200_000;
    }

    function managerId() external pure override returns (uint) {
        return 11111;
    }

    function idNumber() external pure override returns (uint) {
        return 0;
    }
}

contract InheritanceSubmission is IInheritanceSubmission {
    SalesPerson private _salesPerson;
    EngineeringManager private _engineeringManager;

    constructor() {
        _salesPerson = new SalesPerson();
        _engineeringManager = new EngineeringManager();
    }

    function salesPerson() external view override returns (address) {
        return address(_salesPerson);
    }

    function engineeringManager() external view override returns (address) {
        return address(_engineeringManager);
    }
}
