const { expect } = require("chai");

describe("CrowedFunding Contract", function () {
  let Funding;
  let hardhatToken;
  let manager;
  let address1;
  let address2;

  beforeEach(async function () {
    [manager, address1, address2] = await ethers.getSigners();
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
  });

  describe("Transactions", function () {
    it("should cross minimum Contribution before beacame contributer", async function () {
      await expect(hardhatToken.sendEth()).to.be.revertedWith(
        "Minimum contribution of 100 wei required."
      );
    });

    it("should transfer balance to other account", async function () {
      await hardhatToken.makeTransaction(address1.address, 500);
      expect(await hardhatToken.balanceOf(address1.address)).to.equals(500);
    });

    // it("should increase contract balance after transaction", async function () {
    //   await hardhatToken.makeTransaction(address1.address, 500);
    //   await hardhatToken.connect(address1).sendEth();
    //   expect(await hardhatToken.getContractBalance()).to.equals(500);
    // });
  });
});
