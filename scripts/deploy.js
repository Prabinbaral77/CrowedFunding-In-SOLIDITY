async function main() {
  const Funding = await ethers.getContractFactory("CrowedFunding");
  const funding = await Funding.deploy(36000, 1000);
  console.log("deployed sucessfully at address of: " + funding.address);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
