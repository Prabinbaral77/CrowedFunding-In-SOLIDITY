async function main() {
  const Funding = await ethers.getContractFactory("Funding");
  const funding = await Funding.deploy();
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
