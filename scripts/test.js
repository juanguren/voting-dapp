const hre = require("hardhat");

async function main() {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const { address: proposalAddress } = await deployProposalContract();
  const vote = await deployVoterContract(proposalAddress);

  // *********************************************************************

  const saveUser = await vote.newVoter("Juan", 26);
  await saveUser.wait();

  const voters = await vote.getVoters();
  console.log({ voters });

  const getVoter = await vote.getVoter();
  const { name, age, hasVoted, proposalId } = getVoter;
  console.log({ name, hasVoted });

  const buildProposal = await vote.buildProposal(
    owner.address,
    "Test Proposal",
    5,
    new Date().getTime(),
    0
  );
  await buildProposal.wait();

  const voteProposal = await vote.voteProposal(0, new Date().getTime());
  await voteProposal.wait();

  const {
    name: propName,
    isActive,
    voteCount,
    createdAt,
    lastVotedAt,
    createdBy,
    goal,
  } = await vote.getProposal(0);
  console.log({
    propName,
    isActive,
    voteCount: Number(voteCount.toString()),
    createdAt: new Date(createdAt * 1000),
    lastVotedAt: new Date(lastVotedAt * 1000),
    createdBy,
    goal: goal.toString(),
  });
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
