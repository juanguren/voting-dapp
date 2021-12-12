const hre = require("hardhat");

async function main() {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const { address: proposalAddress } = await deployProposalContract();
  const vote = await deployVoterContract(proposalAddress);

  // *********************************************************************

  const saveUser = await vote.newVoter(owner.address, "Juan", 26);
  await saveUser.wait();

  const saveUserR = await vote.newVoter(randomPerson.address, "Hugo", 26);
  await saveUserR.wait();

  const voters = await vote.getVoters();
  console.log({ voters });

  const getVoter = await vote.getVoter(owner.address);
  const { name, age, hasVoted, proposalId } = getVoter;
  console.log({ name, hasVoted });

  const buildProposal = await vote.buildProposal(
    owner.address,
    "Test Proposal",
    20,
    new Date().getTime(),
    0
  );
  await buildProposal.wait();
}

const deployProposalContract = async () => {
  const Proposal = await hre.ethers.getContractFactory("Proposal");
  const proposal = await Proposal.deploy();

  return await proposal.deployed();
};

const deployVoterContract = async (address) => {
  const User = await hre.ethers.getContractFactory("User");
  const vote = await User.deploy(address);

  return await vote.deployed();
};

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
