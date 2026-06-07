const cpuEl = document.getElementById('cpu')
const ramEl = document.getElementById('ram')
const discoEl = document.getElementById('disco')
const saludEl = document.getElementById('salud')
const fechaEl = document.getElementById('fecha')
const sistemaEl = document.getElementById('sistema-nombre')

const ctx = document.getElementById('cpuChart').getContext('2d')
const cpuData = {labels:[], datasets:[{label:'CPU %',data:[],borderColor:'#60a5fa',backgroundColor:'rgba(96,165,250,0.12)',fill:true,tension:0.25}]}
const cpuChart = new Chart(ctx,{type:'line',data:cpuData,options:{responsive:true,plugins:{legend:{display:false}},scales:{y:{suggestedMin:0,suggestedMax:100}}}})

function humanGB(gb){return `${gb} GB`}

async function fetchStatus(){
  try{
    const res = await fetch('/status')
    if(!res.ok) throw new Error('no data')
    const j = await res.json()
    sistemaEl.textContent = j.sistema || 'Desconocido'
    cpuEl.textContent = `${j.cpu_uso_porcentaje} %`
    ramEl.textContent = `${j.ram_disponible_gb} GB`
    discoEl.textContent = `${j.disco_usado_porcentaje} %`
    saludEl.textContent = j.estado_salud || '—'
    fechaEl.textContent = j.fecha_utc || '—'

    // chart
    const now = new Date().toLocaleTimeString()
    cpuData.labels.push(now)
    cpuData.datasets[0].data.push(j.cpu_uso_porcentaje)
    if(cpuData.labels.length>20){cpuData.labels.shift(); cpuData.datasets[0].data.shift()}
    cpuChart.update()
  }catch(e){
    console.error('Failed to fetch status',e)
  }
}

fetchStatus()
setInterval(fetchStatus,2000)
