import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as DIP20_idl, canisterId as DIP20_id } from 'dfx-generated/DIP20';

const agent = new HttpAgent();
const DIP20 = Actor.createActor(DIP20_idl, { agent, canisterId: DIP20_id });

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  const greeting = await DIP20.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
