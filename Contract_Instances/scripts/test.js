const hre = require('hardhat');

async function main() {
  const [owner, randomPerson] = await hre.ethers.getSigners();

  const VoteTest = await hre.ethers.getContractFactory('VoteTest');
  const vote = await VoteTest.deploy();
  await vote.deployed();

  const voteSent = await vote.castVote(owner.address);
  await voteSent.wait();

  const anotherVote = await vote.castVote(randomPerson.address);
  await anotherVote.wait();

  const hasVoted = await vote.checkVote(randomPerson.address);
  console.log({
    voteStatus: {
      hasVoted: hasVoted[0],
      timestamp: new Date(hasVoted[1] * 1000),
    },
  });

  const getVoteBack = await vote.retrieveLiquidVote(owner.address);
  getVoteBack.wait();

  const total = await vote.checkTotalVotes();
  console.log({ total: total.toString() });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
