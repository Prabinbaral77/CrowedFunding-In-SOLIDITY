const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CrowedFunding Contract", function () {
  let Funding;
  let hardhatToken;
  let manager;

  beforeEach(async function () {
    [manager] = await ethers.getSigners();
    Funding = await ethers.getContractFactory("CrowedFunding");
    hardhatToken = await Funding.deploy();
  });

  describe("deployment", function () {
    it("should set the right owner", async function () {
      expect(await hardhatToken.manager()).to.equal(manager.address);
    });

    it("should assign right deadline to every contributer", async function () {
      expect(await hardhatToken.deadline()).to.equal(
        Math.ceil(new Date().getTime() / 1000) + 36000
      );
    });

    it("should assign the right target for funding", async function () {
      expect(await hardhatToken.target()).to.equal(10000);
    });

    it("should assign the right target for funding", async function () {
      expect(5).to.equal(5);
    });
  });
});
