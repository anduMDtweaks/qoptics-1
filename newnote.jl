### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 970718ad-b2a6-4285-899e-ed29ffc8dc85
begin
using PlutoUI
PlutoUI.TableOfContents()
end

# ╔═╡ 4eb251c5-2323-4185-8320-d33316cbf047
md"""
# Optically-Heralded Entanglement of Superconducting Systems in Quantum Networks

*Supplementary to "Optically-Heralded Entanglement of Superconducting Systems in Quantum Networks" by Stefan Krastanov, Hamza Raniwala, Jeffrey Holzgrafe, Kurt Jacobs, Marko Lončar, Matthew J. Reagor, and Dirk R. Englund 2021, and adapted into a notebook by Adrian Ariton and Alexandru Ariton*

> This notebook explains the tradeoffs between the number of generated entangled Bell pairs and their fidelity. It aims to find an equilibrium between these two, by proposing optical networking via heralding end-to-end entanglement with one detected photon and teleporrtation. This approach offers advantages over traditional methods by leveraging heralding and teleportation, which can overcome limitations associated with low microwave-optical coupling efficiency and added noise. 

The paper this notebook is based on shows that today’s transduction hardware can run the heralding scheme that will be discussed while providing orders of magnitude improvement in the networking fidelity compared to the typical deterministic transduction.

A typical electro-optic transducer uses a $χ^{(2)}$ nonlinear interaction between: 
- a *classical optical pump mode* $\hat{p}$ which can be replaced by a *classical field* with the same amplitude $\hat{p} → \sqrt{⟨n_p⟩}$, where $\sqrt{⟨n_p⟩}$ is the average number of photons in the mode
- an *optical mode* $\hat{a}$
- a *microwave mode* $\hat{b}$

## Hamiltonian for a blue-detuned pump

The first approach is blue-detuning $\hat{p}$ w.r.t $\hat{a}$ and coupling the optical mode to a waveguide ending with a photo detector.

This SPDC process allows us to herald the production of a single microwave photon by detecting a single optical photon. 

Thus we obtain the following non-Hermitian Hamiltonian $[1]$,

$$\hat{H} = \hbar g \hat{a}\hat{b} + H.c. +  i \hbar \frac{\gamma_e}{2} \hat{a}^{\dagger}\hat{a},$$

where 
-  $\gamma_e$ is the extrinsic loss rate of the optical mode and $\gamma_i$ is its intrinsic loss rate, $g_0$ is the single-photon nonlinear interaction rate and
$g = g_0 \sqrt{⟨n_p⟩}$.

- the pump power, P, is related to the number of photons in the pump mode as 
$$⟨n_p⟩ = \frac{4\gamma_e}{(\gamma_e + \gamma_i)^2} \frac{P}{\hbar \omega}$$


- and $\hat{c} = \sqrt{\gamma_e}\hat{a}$ is the collapse operator that describes the detection of the optical photon

"""

# ╔═╡ f1f6c0f6-8281-4ab5-b2b8-b0f1ba3c26e5
md"""### Assumptions and notations

Assumptions:
1. the intrinsic loss rate $\gamma_i$ is negligible (non-zero $γ_i$ will reduce the detection effiiency but not the fidelity)
2.  $\gamma_i + \gamma_e = \gamma \gg g$ , required to ensure that the SPDC process does not populate the cavity mode with more than one photon at any time
3.  the lifetime of the microwave oscillator is infinite

Notations:

- denote a Fock state with $n_a$ photons in optical mode $\hat{a}$ and $n_b$ in microwave mode $\hat{b}$ as $|n_an_b\rangle$
"""

# ╔═╡ 45929b93-3ce5-4db3-a22a-423a28c8f32d
md"""

## Time evolution of a state in the subspace spanned by $|00\rangle$ and $|11\rangle$

The [1] Hamiltonian becomes:

$$\hat{H} = \begin{bmatrix}0 & \hbar g\\\hbar g^{*} &  -i \hbar \frac{\gamma_e}{2}\end{bmatrix},$$

and by plugging in $|\psi\rangle = c_0|00\rangle + c_1|11\rangle$ in the master stochastic equation we obtain the following time evolution:

$$|\psi\rangle = \begin{bmatrix}c_0 \\ c_1\end{bmatrix} = e^{-\gamma_e\frac{ t}{4}}  \begin{bmatrix}\frac{\gamma_e}{4g'} \sinh{g't} + \cosh{g't} \\ -i \frac{g}{g'}\sinh{g't}\end{bmatrix}$$

$$g' = \sqrt{\frac{\gamma_e^2}{16} - |g|^2 }$$

The rate of obtaining a $|11\rangle$ pair on which we can herald the single microwave photon is 

$$r_0 = \frac{4g_0^2⟨n_p⟩\gamma_e}{(\gamma_e + \gamma_i)^2}$$

"""

# ╔═╡ 01177799-1814-40da-ad12-05d5215642fd
# ╠═╡ disabled = true
#=╠═╡
using PlutoUI
  ╠═╡ =#

# ╔═╡ 7920ef3e-d71e-45a5-8043-790dfb2022e7
md"""### Analytical solution for time evolution and numerical comparison"""

# ╔═╡ f833a02d-aba5-4046-9a66-2e7af298a793
md"""We can plot the solution $|\psi\rangle$ using the aforementioned formulas, or we can solve it numerically using julia's DifferentialEquations library. The following code can be modified to solve for any kind of Hamiltonian.
"""

# ╔═╡ 762c3311-da7f-4f0c-b7da-5df285f404cd
md"""Below we plot numerical and analytical solutions for the components of both $|00\rangle$ and $|11\rangle$ of state $|\psi\rangle$ with respect to time. Move the sliders above to modify the set of parameters or to widen the time interval for the graph. 

A logarithmic scale has been chosen for most sliders to facilitate the visualization of a wider range of parameters.
"""

# ╔═╡ cff02deb-0973-4a5c-b905-a38a48ec1e61
md"""`The single-photon nonlinear interaction rate log₁₀(g₀ (kHz)) : `$(slg = @bind log₁₀g₀ Slider(0:0.25:6; default=0, show_value=true))"""

# ╔═╡ ff17c447-bb69-4455-8819-6fa625addc7a
md"""
`Number of photons in the pump mode (logarithmic) log₁₀(nₚ) : `$(slnₚ = @bind log₁₀nₚ Slider(0:0.5:10; default=6, show_value=true))
"""

# ╔═╡ 387227e3-e4d9-4453-8845-b3c730999763
md"""` Extrinsic loss rate γₑ | log₁₀(γₑ (MHz)) : `$(slγₑ = @bind log₁₀γₑ Slider(-4:0.05:4; default=2, show_value=true))"""

# ╔═╡ bf31c280-5e88-42d0-85bb-3ab11378aca1
begin
	g₀ = 10 ^ log₁₀g₀
	nₚ = 10^log₁₀nₚ
	γₑ = 10^log₁₀γₑ
	g = g₀ * sqrt(nₚ)
	if (γₑ)^2 / 16 - (g / 1000)^2 > 0
		gᵖʳᶦᵐᵉ = sqrt((γₑ)^2 / 16 - (g / 1000)^2)
	else
		gᵖʳᶦᵐᵉ = im * sqrt(-((γₑ)^2 / 16 - (g / 1000)^2))
	end
	 # in MegaHerz
	md"""`Deduced parameters:`"""
end

# ╔═╡ 1164cc37-2062-4ff9-8463-9edfb21db77a
begin
tᶠᶦⁿ = 20 / γₑ # time interval in microseconds
md"""`The time interval above will be used for all the graphs below`"""
end

# ╔═╡ 10209491-8d9f-4056-9358-09101e533dd5
begin
	using DifferentialEquations
	MHz = 1e6
	kHz = 1e3
	MkHz = 1e3
	factor = 1e6 	# time is ploted in units of 1 microseconds

	H = [0 g*kHz/factor
		 conj(g * kHz)/factor  -im * γₑ * MHz/(2.0)/factor] # H in Hz
	
	f(ψ, p, t) = -im * H * ψ

	# Initial condition: fock state at t=0
	ψ0 = [1.0 + 0.0im
		0.0 + 0.0im]
	
	tspan = (0.0, tᶠᶦⁿ)
	schrodinger = ODEProblem(f, ψ0, tspan)

	# c_0 and c_1 are extracted from sol
	sol = solve(schrodinger; dt=1e-8)
end;

# ╔═╡ cdf312f8-2ed1-49f0-9b85-d3ad58b31ec7
begin
	tspan_small = (0.0, 10.0)
	schrodinger_small = ODEProblem(f, ψ0, tspan_small)

	# c_0 and c_1 are extracted from sol
	sol_small = solve(schrodinger_small; dt=1e-8)
	md"""### State visualization in time"""
end

# ╔═╡ 91ce7b5d-cbcc-4cf5-8999-c2edd5e2bccf
begin
	deltat = tᶠᶦⁿ/1000
	t = 0:deltat:tᶠᶦⁿ
	t_small = 0:0.1:10
	
	using Plots
	
	nt2 = length(sol.t)
	c0ᵣₑₐₗ = zeros(nt2)
	c1ᵣₑₐₗ = zeros(nt2)
	
	c0ᵢₘ = zeros(nt2)
	c1ᵢₘ = zeros(nt2)

	c0ᵃᵇˢ = zeros(nt2)
	c1ᵃᵇˢ = zeros(nt2)
	
	for i in 1:nt2
	    c0ᵣₑₐₗ[i] = real(sol.u[i][1])
	    c1ᵣₑₐₗ[i] = real(sol.u[i][2])

		c0ᵢₘ[i] = imag(sol.u[i][1])
		c1ᵢₘ[i] = imag(sol.u[i][2])

		c0ᵃᵇˢ[i] = abs(sol.u[i][1])
		c1ᵃᵇˢ[i] = abs(sol.u[i][2])
	end

	# plot(sol.t,  c0ᵣₑₐₗ, linewidth=3, ls=:dash, label = "\$real(c_0)\$")
	# plot(sol.t,  c0ᵣₑₐₗ, linewidth=3, ls=:dash, label = "\$real(c_0)\$")
	
	
end;

# ╔═╡ f2fbc3f0-8a51-43e6-8e15-15e2fa61124f
Markdown.parse("""
|g             | nₚ    | gᵖʳᶦᵐᵉ            |time interval      |γₑ       |
|:-------------|:------|:------------------|:---------|:--------|
|`$g` kHz      | `$nₚ` | `$gᵖʳᶦᵐᵉ` MHz     | `[0, $(tᶠᶦⁿ)]` µs |`$γₑ` MHz|
""")


# ╔═╡ d09b3c71-8049-4bf6-b00f-0c93e438ec51
begin
	function analytical_components(t)	# t is in units of 1e-7 seconds
		# c1 analitically in time
		c1ᵃⁿᵃˡʸᵗᶦᶜ = im * -exp.(-γₑ * MHz / 4 * (t / factor)) .* (g * kHz / (gᵖʳᶦᵐᵉ * MHz)) .* sinh.(gᵖʳᶦᵐᵉ * MHz * (t / factor))
	
		# c0 analytically
		c0ᵃⁿᵃˡʸᵗᶦᶜ = exp.(-γₑ * MHz / 4 * (t / factor)) .* (
			(γₑ * MHz / (4 * gᵖʳᶦᵐᵉ * MHz)) .* sinh.(gᵖʳᶦᵐᵉ * MHz * (t / factor)) .+ cosh.(gᵖʳᶦᵐᵉ * MHz * (t / factor)))
	
		return c0ᵃⁿᵃˡʸᵗᶦᶜ, c1ᵃⁿᵃˡʸᵗᶦᶜ
	end

	function analytical_components(dt, g) 
		# dt is in units of 1e-7 seconds, g in kiloherz
		gᵖʳᶦᵐᵉv = sqrt.(Complex.((γₑ)^2 / 16 .- (g / 1000).^2.)) # in MHz
		
		# c1 analitically vs g
		c1ᵃⁿᵃˡʸᵗᶦᶜ = im * -exp(-γₑ * MHz / 4 * (dt / factor)) * (g * kHz ./ (gᵖʳᶦᵐᵉv * MHz)) .* sinh.(gᵖʳᶦᵐᵉ * MHz * (dt / factor))
	
		# c0 analitically vs g
		c0ᵃⁿᵃˡʸᵗᶦᶜ = exp.(-γₑ * MHz / 4 * (dt / factor)) * (
			(γₑ * MHz ./ (4 * gᵖʳᶦᵐᵉv * MHz)) .* sinh.(gᵖʳᶦᵐᵉv * MHz * (dt / factor)) .+ cosh.(gᵖʳᶦᵐᵉ * MHz * (dt / factor)))
	
		return c0ᵃⁿᵃˡʸᵗᶦᶜ, c1ᵃⁿᵃˡʸᵗᶦᶜ
	end

	c0ᵃⁿᵃˡʸᵗᶦᶜ, c1ᵃⁿᵃˡʸᵗᶦᶜ = analytical_components(t)

	# ploting graphs

	# Real(c0)
	c0ᵖˡᵒᵗ = plot(t,  abs.(c0ᵃⁿᵃˡʸᵗᶦᶜ), xaxis=false, label="\$|c_0|\$ analytical",c=1)
			 plot!(sol.t,  c0ᵃᵇˢ, linewidth=3, ls=:dash, label = "\$|c_0|\$ numerical", c=1)

	# Imag(c1)
	c1ᵖˡᵒᵗ = plot(t,  abs.(c1ᵃⁿᵃˡʸᵗᶦᶜ), label="\$|c_1|\$ analytical", c=2)
			 plot!(sol.t,  c1ᵃᵇˢ,   linewidth=3, ls=:dash, label = "\$|c_1|\$ numerical", c=2, xaxis="time (µs)")

	
	
	plot(
	    c0ᵖˡᵒᵗ,
	    
		c1ᵖˡᵒᵗ, 
		
		layout = grid(2, 1, heights=[0.5, 0.5])
	)

	
end

# ╔═╡ 76ba8fca-8425-4991-a04c-957c5748caa4
html"""<sub><sup>
One can check out and modify the code by clicking the eye icon on the left of the graph.</sup></sub>"""

# ╔═╡ c746c416-e559-45a3-84be-f21ab256a5a3
md"""
## Rate of photon generation and of generating Bell pairs
"""

# ╔═╡ 5989cbc6-9e3e-46bf-9e70-8ea992629a9d
md"""
To obtain a $|11\rangle$ pair on which we can herald the single microwave photon we simply pump the system on the blue-detuned optical mode and let the Hamiltonian evolve,
while waiting for a click at the detector. A click heralds
the creation of single photon in the microwave mode. This is called **single-click event**
"""

# ╔═╡ ee358a4b-5c94-4bd1-b2a2-3c9846abf38f
md""""""

# ╔═╡ fdf8a09a-ff61-4f93-98eb-ceee6f99b1bc
md"""### Rate of photon generation
"""

# ╔═╡ 2f830af9-8d21-4b25-add5-6842f0ca0ba5
md"""
Restricting ourselves to the space spanned by $|00\rangle$ and $|11\rangle$, we can easily find **the probability that the photon remains undetected at time t** as the squared norm of $|\psi\rangle$:

$$|c_0|^2 + |c_1|^2 = \langle\psi(t)|\psi(t)\rangle \sim e^{(2g' - \frac{\gamma_e}{2})t} \sim e^{-\frac{4|g|^2}{\gamma_e}t}$$


which is consistent to the previous deduction of $r_0$ as it corresponds to a Poissonian detection process with rate
	$r_0 = \frac{4g_0^2⟨n_p⟩\gamma_e}{(\gamma_e + \gamma_i)^2},$ accounting for the  $\frac{\gamma_e}{\gamma_e + \gamma_i}$ drop in efficiency.

Below we plot the rate of photon generation $r_0$ with respect to time. The afforementioned Poissonian approximation is also ploted in order check that they are infact similar.
"""

# ╔═╡ 2c03e491-a652-4548-afae-3384788c0b2b
begin
function get_regime(g, γₑ)
	raport = g * kHz / (γₑ * MHz)
	message = "Respecting our regime"
	if raport > 0.25
		message = "Tons of oscilations (g' is imaginary)"
	elseif raport > 0.1
		message = "Outside of our regime"
	elseif raport > 0.01
		message = "Begining to break the regime"
	end
	return message
end
	md""""""
end

# ╔═╡ aa27c4d0-161c-44af-a235-8cffd0e17393
md"""Show $e^{(2g' - \frac{\gamma_e}{2})t}$ ` approximation : `$(@bind approx2 CheckBox(default=false))"""

# ╔═╡ 21aebabf-c60f-444d-9d45-36df2ac3ab38
md"""` Extrinsic loss rate γₑ | log₁₀(γₑ (MHz)) : `$slγₑ"""

# ╔═╡ 71539848-3b56-4d37-a25d-85c6feb3c9c9
Markdown.parse("""
|g / γₑ            | Comments 				   |
|:-----------------|:--------------------------|
|`$(g * kHz / (γₑ * MHz))`      | `$(get_regime(g, γₑ))`    |
""")


# ╔═╡ a642d935-e0e4-4f89-ad12-083ab719f7dd
begin
	plot(title="Probability that the photon remains undetected in time")
	
	plot!(t, exp.(-4*abs(g * kHz)^2 / (γₑ * MHz) * t / factor), linewidth=1, label = "Poissonian Aproximation", c=1)

	if approx2
		plot!(t, real(exp.((2 * gᵖʳᶦᵐᵉ - γₑ/2) *MHz * t / factor)), linewidth=1, ls=:dash, label = "Aproximation [Real Part]", c=1)
		
		if real(gᵖʳᶦᵐᵉ) == 0
			plot!(t, imag(exp.((2 * gᵖʳᶦᵐᵉ - γₑ/2) *MHz * t / factor)), linewidth=1, ls=:dashdotdot, label = "Aproximation [Imaginary Part]", c=1)
		end
	end
	plot!(sol.t,  c0ᵣₑₐₗ .* c0ᵣₑₐₗ +  c1ᵢₘ .* c1ᵢₘ, linewidth=1, ls=:dash, label = "\$\\langle\\psi(t)|\\psi(t)\\rangle\$ (numerical)", c=2, xaxis="time (.1µs)")

	plot!(t,  (abs.(c0ᵃⁿᵃˡʸᵗᶦᶜ) .^ 2 + abs.(c1ᵃⁿᵃˡʸᵗᶦᶜ) .^ 2), label = "\$\\langle\\psi(t)|\\psi(t)\\rangle\$ (analytical solution)", linewidth=1, c=2)

	
end

# ╔═╡ b3004e4f-0963-483d-b70e-b5ead79791b8
html"""
	<sub><sup>Click the eye icon to the left to see or modify the code the plots the following graph</sup></sub>
	"""

# ╔═╡ dcc5bb82-0418-4589-a036-073e23afbb1c
md"""
As we can notice from the figure, the probability that the photon remains undetected at a given time can be modeled with a **Poissonian detection event with rate** $r_0$ when $g \ll \gamma_e$. 

However if $g$ is significantly large, or $\gamma_e$ is significantly small w.r.t $g$, our regime begins to break and the approximation is no longer that accurate, although it can still be useful to some degree. We also notice that the rate of photon generation $r_0$ gets bigger (the graph gets further away from the Y axis) as $\gamma_e$ gets smaller, which is expected.

In the following section we explore the way coupled coherent pumps help us generate entangled bell pairs as well as the balance between their rate of generation and their fidelity.
"""

# ╔═╡ 6a3e0878-f0a8-49a5-a23d-3edf98c0fc56
md""""""

# ╔═╡ 71d37f34-2163-4208-a106-54adff1b791c
md"""### Heralding the generation of distributed microwave Bell pairs

If we use the same coherent pump to drive two separate copies of this system and erase the which-path information using a beam splitter, we will herald the generation of the distributed microwave Bell pair $|01\rangle \pm |10\rangle$
in the following steps
- The blue-detuned pump will create pairs of microwave/optical photons.
- By detection of the optical photons after erasing the path information (for example with a beam splitter) we can herald entanglement between the microwave oscillators (this is a high-fidelity, low-efficiency probabilistic operation)

However, if the nodes have different interaction rates $g$ and couplings $\gamma_e$, the Bell pair would not be pure, hence the **infidelity**:

$$c_{1 r}|01\rangle \pm c_{1 l}|10\rangle. \text{ [2]}$$


"""

# ╔═╡ cfe37f4c-1c34-47a1-9984-e38a3433a5de
md""""""

# ╔═╡ ef75728f-0b9f-41ce-9b36-1689952858be
md"""### Bell pairs generation rate

Solving for the Poissonian distribution, using

$${\displaystyle P(k{\text{ events in interval }}t)={\frac {(rt)^{k}e^{-rt}}{k!}}},$$
we obtain 

$$p_{\delta} := P(1{\text{ click in the duration of each pump pulse}}) = r_0\Delta t e^{-r_0\Delta t}.$$

Accounting for the time necessary for the reset of the microwave cavity after each attempt ($t_r$), we obtain an **entanglement generation rate** equal to

$$r_e =  \frac{2p_{\delta}}{\Delta t + t_r} = 2r_0e^{-r_0\Delta t}\frac{\Delta t}{\Delta t + t_r},$$

where
-  $\Delta t$ is the duration of each pump pulse
-  $t_r$ is the time necessary for the reset of the microwave cavity (usually on the order of microseconds)

**The probability of more than one event during the interval $∆t$ are generally negligible, but lead to infidelities in this protocol at high entanglement rates.**"""

# ╔═╡ e008a26b-f4b2-4106-b982-69bc34af0c4e
md""""""

# ╔═╡ fe0a2c93-b0d1-4e47-b760-feeea03a7ace
md"""
### Visualizing the entanglement rate vs pump mode power

In order to express the entanglement rate $r_e$ (Bell pairs generation rate) with respect to $P$, the power of the pump mode $\hat{p}$, we need to rewrite a few of the afforementioned formulas:

$$r_e = 2r_0e^{-r_0\Delta t}\frac{\Delta t}{\Delta t + t_r}\text{, where } $$ $$ r_0 = \frac{4g_0^2⟨n_p⟩\gamma_e}{(\gamma_e + \gamma_i)^2}= 16g_0^2\frac{P}{\hbar\omega}\frac{\gamma_e^2}{(\gamma_e + \gamma_i)^4} [*] \text{, because}$$
 
$$⟨n_p⟩ = \frac{4\gamma_e}{(\gamma_e + \gamma_i)^2} \frac{P}{\hbar \omega}$$

As one notices from the final formula $[*]$, the entanglement rate scales as $\frac{\gamma_e^2}{(\gamma_e + \gamma_i)^4}$ with respect to the $\hat{p}$ pump power, so it is maximum when $\gamma_e = \gamma_i$.

Below we plot the entanglement rate $r_e$ with respect to the power of and the number of photons in the pump mode $\hat{p}$. One can vizualize the entanglement rate when $\gamma_e = \gamma_i$ (maximum entanglement rate), as well as when there is no intrinsic loss rate ($\gamma_i = 0$) by toggling the `Guides` option.
"""

# ╔═╡ ff33d221-ed21-4f84-83a9-83319f05b375
md"""We also plot the entanglement rate after  [purification](#c6d24b06-f1aa-4733-969c-a153aae99257), which is descussed in the later sections."""

# ╔═╡ c82a5807-ccba-41a7-b3c2-cd4e5bac0ecb
md""""""

# ╔═╡ c5a2437e-c77f-4a04-84ce-cb73a682fac5
md"""` Pump pulse duration: ∆t (.1µs)  : `$(sldtµs = @bind dtµs Slider(1:0.01:10; default=1, show_value=true))"""

# ╔═╡ 7ab52be5-fecd-440d-bd5d-60489ff10f3b
md"""` Extrinsic loss rate γₑ | log₁₀(γₑ (MHz)) : `$slγₑ"""

# ╔═╡ 7a602c0a-2615-44ad-af85-4e67f4ab1070
md"""`The single-photon nonlinear interaction rate log₁₀(g₀ (kHz))` : $slg """

# ╔═╡ ab51bd5c-a3a4-40ce-a4b1-343d5d938f8c
md"""` γᵢ/γₑ : `$(slγᵢfγₑ = @bind γᵢfγₑ Slider(0:0.01:1; default=1, show_value=true))"""

# ╔═╡ 393d4d88-da1a-4aba-bb82-ba1d3e8ec7a3
md"""`Logarithmic y(entanglement rate) axis logʳᵃᵗᵉ : `$(sllogʳᵃᵗᵉ = @bind logʳᵃᵗᵉ CheckBox(default=true))"""

# ╔═╡ e2d9c02f-d7aa-4d3a-9a1d-2a0ef14d74ad
md"""`Guide : `$(@bind guide CheckBox(default=false))"""

# ╔═╡ 8dfaa441-de2e-47f4-869d-bf4471541b22
Markdown.parse("""
|g / γₑ            | Comments 				   |
|:-----------------|:--------------------------|
|`$(g * kHz / (γₑ * MHz))`      | `$(get_regime(g, γₑ))`    |
""")

# ╔═╡ ef86c88a-264b-4c5b-a916-0a5036d7c3ef
Markdown.parse("""
|g             | nₚ    | gᵖʳᶦᵐᵉ            |g₀      |γₑ       |
|:-------------|:------|:------------------|:---------|:--------|
|`$g` kHz      | `$nₚ` | `$gᵖʳᶦᵐᵉ` MHz     | `$g₀` kHz |`$γₑ` MHz|
""")


# ╔═╡ ecedd49b-e036-4c9a-94c4-a8e119309dc2
begin
	function entanglement_rate(log_range, γₑ, γᵢ, g₀, dt, tr; power=false, moreevents=false, logy=false, purification=false)
		if power ==false
			r0vec = 4 * (g₀ * kHz)^2 * (10 .^ log_range) * (γₑ * MHz) / (γₑ * MHz + γᵢ * MHz)^2
		else
			logpspan = -log10( 4 * (γₑ * MHz) / (γₑ * MHz + γᵢ * MHz)^2) .+ log_range
			npspan = (4 * (γₑ * MHz) / (γₑ * MHz + γᵢ * MHz)^2 * (10 .^ (logpspan)))
			r0vec = 4 * (g₀ * kHz)^2 * npspan * (γₑ * MHz) / (γₑ * MHz + γᵢ * MHz)^2
		end
	
		if moreevents == false
			revec = 2 * r0vec .* exp.(- r0vec * dt) * dt / (dt + tr)
		else
			revec = 2 * r0vec .^ 2 .* exp.(- r0vec * dt) * dt ^ 2 / 2 / (dt + tr) 
		end

		if purification
			revec=  revec / 2
		end

		if logy
			return log10.(revec)
		else
			return revec
		end
	end

	logpowerspan(log_range, γₑ, γᵢ) = -log10( 4 * (γₑ * MHz) / (γₑ * MHz + γᵢ * MHz)^2) .+ log_range

	md""""""
end

# ╔═╡ aa70bca1-61f0-4e60-937b-3b42a0b4d493
begin
	γᵢ = γᵢfγₑ * γₑ
	if g₀ < 200
		lognₚspan = 6:0.1:9.5
	elseif g₀ < 1e4
		lognₚspan = 0:0.1:9.5
	elseif g₀ < 1e8
		lognₚspan = -10.0:0.1:9.5
	end

	nₚspan = 10 .^ lognₚspan
	
	logpspan = logpowerspan(lognₚspan, γₑ, γᵢ)

	pspan = 10 .^ logpspan
	
	scalingfactor 	= 16 * ((γₑ * MHz) / (γₑ * MHz + γₑ * MHz)^2)^2
	dt 			  	= dtµs * 1e-7 # dt is in seconds
	tr 				= 1e-6
	
	revec     = entanglement_rate(lognₚspan, γₑ, γᵢ, g₀, dt, tr; logy=logʳᵃᵗᵉ)
	revecmax  = entanglement_rate(lognₚspan, γₑ, γₑ, g₀, dt, tr; logy=logʳᵃᵗᵉ)
	revec0    =	entanglement_rate(lognₚspan, γₑ, 0 , g₀, dt, tr; logy=logʳᵃᵗᵉ)
		
	revec_pure= entanglement_rate(lognₚspan, γₑ, γᵢ, g₀, dt, tr; logy=logʳᵃᵗᵉ, purification=true)

	revecp    =	entanglement_rate(lognₚspan, γₑ, γᵢ, g₀, dt, tr; power=true, logy=logʳᵃᵗᵉ)
	revecpmax = entanglement_rate(lognₚspan, γₑ, γₑ, g₀, dt, tr; power=true, logy=logʳᵃᵗᵉ)
	revecp0   =	entanglement_rate(lognₚspan, γₑ, 0 , g₀, dt, tr; power=true, logy=logʳᵃᵗᵉ)

	revecmany = entanglement_rate(lognₚspan, γₑ, 0 , g₀, dt, tr; moreevents=true, logy=logʳᵃᵗᵉ)

	
	plotnp = plot(title="Entanglement Rate (Hz)",legend=:bottomleft)

	if guide
		plot!(nₚspan, revecmax, label="\$r_e\$ (γₑ = γᵢ)", c=2)
		plot!(nₚspan, revec0, label="\$r_e\$ (γᵢ = 0)", c=2, ls=:dash)
	end

	plot!(nₚspan, revec, label="\$r_e\$ [1 click event]", c=1)
	plot!(nₚspan, revecmany .+ revec, xaxis="nb of photons in the pump mode", label="\$r_e\$ [1 or 2 click events]", c=1, ls=:dash)
	plot!(nₚspan, revec_pure, label="\$r_e\$ (+ purification)", c=3, ls=:dashdot)
	
	plotpower = plot(legend=:none, yaxis=false, xaxis="Power / \$\\hbar\\omega\$")
	plot!(pspan, pspan * 0, color=:black)
	#if guide
	#	plot!(pspan, revecpmax, label="\$r_e\$ (γₑ = γᵢ)", c=2)
	#	plot!(pspan, revecp0, label="\$r_e\$ (γᵢ = 0)", c=2, ls=:dash)		

	#end

	# plot!(pspan, revecp, xaxis="Power / \$\\hbar\\omega\$", label="\$r_e\$", c=1)
	# plot!(pspan, revecp, label="\$r_e\$ (+ purification)", c=3, ls=:dashdot)

	
	if (logʳᵃᵗᵉ == true)
		plot(plotnp, plotpower, layout = grid(2, 1, heights=[0.99, 0.01]), xscale=:log10, ylimits=(0,maximum(revecmax))) # TODO: find way to use yscale=:log10 without it crashing. cutoff unimportant examples (y < 1 => cut)
	else
		plot(plotnp, plotpower, layout = grid(2, 1, heights=[0.99, 0.01]), xscale=:log10)
	end
end

# ╔═╡ 7c96056a-1d20-4f69-b7c9-9c49d250fce4
html"""
	<sub><sup>
Click the eye icon to the left to see or modify the code the plots the following graph</sup></sub>
	"""

# ╔═╡ d146c7d9-94c3-4220-b2c3-7f9025a4c04d
md"""Remember that a click event heralds the creation of single photon in the microwave mode.

As we can see, keeping the ratio between the intrinsic and extrinsic loss rates equal to 1, the entanglement rate scales as $\gamma_e^{-2}$. 

So we can see that, when keeping g constant, **as $\gamma_e$ gets smaller**, i.e. we begin to break our regime, the **entanglement rate increases**, however, as we will see in the following section, the **fidelity of the generated bell pairs gets smaller**. We need to find the balance between the two!

Also given that the ratio of photons that actually reach the photodetector is equal to $\frac{\gamma_e}{\gamma_e + \gamma_i} = 0.5$, we miss half of the heralding events when the maximal entanglement rate is reached ($\gamma_e = \gamma_i$). 

Due to missing half of the healding events we need to reset the microwave cavity after each attempt which results in a delay of $\sim 1 µs$ that limits the maximal entanglement rate."""

# ╔═╡ 33571876-74b4-4a39-a541-f777880d7fce
md"""Typical hardware parameters of state-of-the-art devices ($γ_e = γ_i = 100MHz$   and $g_0 = 1kHz$) will allow pair generation rates of $100kHz$ at fidelities of $0.99$, while suffering $0.1mW$ of in-fridge heating due to leakage from the pump."""

# ╔═╡ 1d2966c0-9e43-44b7-af69-d355717d7353
md"""Through [purification](#c6d24b06-f1aa-4733-969c-a153aae99257), the entanglement rate is halved (green dash-dot line) to increase fidelity, as we will see in the [next sections](#c6d24b06-f1aa-4733-969c-a153aae99257)"""

# ╔═╡ a5f936fb-9866-46ce-9c60-0ab21a67c961
md"""### Visualizing entanglement infidelity"""

# ╔═╡ 4136d7c6-3eda-4a80-9a44-8b57e7088b1c
md"""Below we plot the entanglement infidelity of $|\psi\rangle$, calculated as $1-\langle\psi|\rho|\psi\rangle$ at time $∆t$, where $\rho = |A\rangle\langle A|$ and $|A\rangle \sim |00\rangle + |11\rangle$ w.r.t the number of photons in pump mode $\hat{p}$.

*TODO: check if plot is actually ok:) (the infidelity should be smaller)*"""

# ╔═╡ 9b86f97f-8645-4074-9370-1ea4d204cb33
md"""` Pump pulse duration: ∆t (.1µs)  : `$sldtµs"""

# ╔═╡ 9795091c-77b8-416d-8b58-adc0686dd4e6
md"""` Extrinsic loss rate γₑ | log₁₀(γₑ (MHz)) : `$slγₑ"""

# ╔═╡ b5747e4f-a300-4705-80f7-2e5ec1184041
md"""` γᵢ/γₑ : `$slγᵢfγₑ"""

# ╔═╡ b20c1921-9935-4013-b74e-830db0f82023
md"""`Logarithmic y(entanglement rate) axis logʳᵃᵗᵉ : `$sllogʳᵃᵗᵉ"""

# ╔═╡ fedf62db-d9f0-4edf-904e-bb14885ac80b
Markdown.parse("""
|g / γₑ            | Comments 				   |
|:-----------------|:--------------------------|
|`$(g * kHz / (γₑ * MHz))`      | `$(get_regime(g, γₑ))`    |
""")

# ╔═╡ 9b170d18-9d9f-4863-b98b-4e8a8c6b836d
begin
	# real part of c0 and imaginary of c1
	c0dtr, c1dtr = analytical_components((dt + tr) * factor, real(g₀ * sqrt.(nₚspan)))
	c0dt, c1dt = analytical_components((dt + 0) * factor, real(g₀ * sqrt.(nₚspan)))

	## Trying to plot the infidelity vs pump photons
	infidelity1 = 1 .- 1 * (abs.(c0dt).^ 2 .+ abs.(c1dt).^ 2)  # no reset time included
	infidelity1r = 1 .- 1 * (abs.(c0dtr).^ 2 .+ abs.(c1dtr).^ 2) # with reset time included

	plotinfidelities = plot(title="Infidelitiy vs nb of photons in p", xaxis="nb of photons in the pump mode", legend=:bottomright)
	plot!(nₚspan, infidelity1 , label="Infidelity? (\$t_r = 0\$)")
	plot!(nₚspan, infidelity1r , label="Infidelity?")

	
	if (logʳᵃᵗᵉ == true)
		plot(plotinfidelities, xscale=:log10, yscale=:log10, ylimits=(1e-4,1))
	else
		plot(plotinfidelities, xscale=:log10)
	end
end

# ╔═╡ 8d76397d-7d0b-4fc3-9990-da676c5ae22b
md"""As predicted before, when keeping g constant, bigger extrinsic loss rates result in smaller infidelities $\implies$ bigger fidelities. 

Subsequently, smaller extrinsic loss rates correspond to smaller fidelities."""

# ╔═╡ 7082e2a0-486f-4803-89e2-409e91cb5a1a
md"""
Notice that the fidelity remains unaffected by an intrinsic loss rate $\gamma_i$
"""

# ╔═╡ e9855f2c-8fc8-40c4-997a-a60a6da3d22b
md"""
TODO: plot other lines from paper (with purification and in-fridge heating) and explain them
"""

# ╔═╡ fa673ba6-677d-41b8-a60d-8519db356c61
md"""
## Reviewing assumptions made and regimes in which they break
Under our [initial assumptions](#f1f6c0f6-8281-4ab5-b2b8-b0f1ba3c26e5):
- an internal loss rate $\gamma_i$ reduces the entanglement generation rate by a factor of $\frac{\gamma_e}{\gamma_e + \gamma_i}$
- an internal loss rate $\gamma_i$ does **NOT** affect the fidelity of the obtained bell pairs (see [2])
- the fidelity remains unchanged by insertion loss in the optical network [3]

Breaking our regime, especially *Assumption 2* ( $g ≪ γ$ ) , the insertion loss  fidelity begins to break for two reasons:
1. the SPDC process will excite states that contain more than one photon
2. there will be a small probability of $\frac{|c_1|^2}{|c_0|^2 + |c_1|^2}$ that the SPDC will simultaneously produce a photon in each of the two resonators

Both scale as $g/\gamma$

Given that the infidelities scale proportionate to $\frac{1}{\gamma}$, and the entanglement rate scales proportionate to $\gamma_e^{-2}$, we notice that higher entanglement rate also means higher infidelities. 

In the following sections we analyze how the infidelities grow when we begin to go outside of our assumptions, and how we can find a balance between the entanglement rate and the Bell pair fidelities.

"""

# ╔═╡ d9a0a623-03f9-458d-ab99-fe8a0446ed3c
md"""### Infidelity due to two-photon-excitations"""

# ╔═╡ 0ed17d30-ca8d-4ccc-bcd7-09c63cec38e0
md"""In the following graph we can visualize the probability that the SPDC will produce photon in both resonators. This graph allows us to see how the infidelity grows with respect to $g / γₑ$

One can modify the first two sliders in order to increase $g$ which is equal to $g_0\sqrt{⟨n_p⟩}$ or modify the 3rd slider to decrease $\gamma_e$ to see how breaking the assumed regime increases the two-photon-excitation infidelity"""

# ╔═╡ d42743b8-7a16-4445-adfd-82809b1d9d58
md"""`The single-photon nonlinear interaction rate log₁₀(g₀ (kHz))` : $slg """

# ╔═╡ 63bb7260-a5b2-4206-9d5c-77684ecfdf36
md"""
`Number of photons in the pump mode (logarithmic) log₁₀(nₚ) : `$slnₚ
"""

# ╔═╡ b0f49879-df51-44b4-99a9-603f338ad884
md"""` Extrinsic loss rate γₑ | log₁₀(γₑ (MHz)) : `$slγₑ"""

# ╔═╡ 2a0e2d1d-6e6e-4081-99bb-ca6eaf696399
Markdown.parse("""
|g / γₑ            | Comments 				   |
|:-----------------|:--------------------------|
|`$(g * kHz / (γₑ * MHz))`      | `$(get_regime(g, γₑ))`    |
""")


# ╔═╡ d11bc08a-641d-426e-8999-805e93afc6ba
begin
	plot(title="Two-photon-excitations infidelity")
	plot!(t, real(abs.(c1ᵃⁿᵃˡʸᵗᶦᶜ).^2 ./ (abs.(c0ᵃⁿᵃˡʸᵗᶦᶜ) .^2 .+ abs.(c1ᵃⁿᵃˡʸᵗᶦᶜ) .^ 2)), xaxis="Time (.1µs )", label="Analytical")

	plot!(sol.t, real(abs.(c1ᵢₘ).^2 ./ (abs.(c0ᵣₑₐₗ) .^2 .+ abs.(c1ᵢₘ) .^ 2)), xaxis="Time (.1µs )", label="Numerical", ls=:dash)
	
	# TODO change to fit
	#plot!(t, (t ./ t) * g * kHz / (γₑ * MHz), ls=:dash, c=2)
	
end

# ╔═╡ e81ca2e2-24f4-4f3c-aa0f-11a9ca9b00f1
md"""As we can see, this probability is negligible when $g ≪ γ_e$, but becomes noticeable when $g / γₑ$ becomes larger. When $g / γₑ$ close to $0.25$, meaning $g' \to 0$, the probability grows even faster, as we begin to test the limits of our regime.

Also when $g / γₑ > 0.25$, we begin to notice oscilations both in the **two-photon-excitations infidelity** as well as in the components of $|\psi\rangle$ itself."""

# ╔═╡ 02543f9e-0fb1-4f6d-8290-1a14e6fd4ecd
md"""## Workarounds

While the second source of infidelity is unavoidable, the first can be eliminated in the two ways:

### 1. Using a red-detuned pump
- instead of a blue-detuned pump, we can employ the traditional red-detuned pump used in transduction together with a particular state preparation procedure in the microwave hardware
- prepare the microwave in the state $|1\rangle$ on reset

This leads to the same ODE as seen for [Hamiltonian 1](#45929b93-3ce5-4db3-a22a-423a28c8f32d), however the basis for the evolving state is now $|ψ\rangle = c_0|01\rangle + c_1|10\rangle$, **and the Hamiltonian can no longer excite states with more than 1 photon.**

$$\hat{H}_{red} = \hbar g \hat{a}\hat{b}^{\dagger} + H.c. + i \hbar \frac{\gamma_e}{2} \hat{a}^{\dagger}\hat{a}$$

We obtain a microwave entangled pair $|00\rangle \pm |11\rangle$

### 2. Keeping the blue-detuned pump

- using a strongly anharmonic microwave resonator that suppresses the two-photon excitation.

We obtain a microwave entangled pair $|01\rangle \pm |10\rangle$
"""

# ╔═╡ c6d24b06-f1aa-4733-969c-a153aae99257
md"""### Purification

The state generated by our heralding process in the case of the **blue-detuned** pump would not be a pure entangled state. Rather, it would be of the form:

$$\rho = (1-\epsilon)|A\rangle\langle A| + \epsilon|B\rangle\langle B| + \epsilon|C\rangle\langle C|,$$
$$|A\rangle = |01\rangle \pm |10\rangle$$
$$|B\rangle = |00\rangle + |11\rangle$$
$$|C\rangle = |00\rangle - |11\rangle,$$
where
-  $|A⟩$ is one of the two possible desired entangled states (in our case $|01\rangle \pm |10\rangle$)
-  $\epsilon$ is a measure of the infidelity

Through simple single-stage purification performed on the microwave superconducting quantum computer the infidelity $\epsilon$ can be lowered by an order of magnitude while incurring a decrease in the rate of just over a factor of two. 

The purification circuit consists of these steps:
- from the generated photons, only half will be purified, while half are used for the porcess of purification (due to the sacrifice, the effective rate is halved)
- a bilateral CNOT operation between the pair to be purified and a sacrificial pair followed by a Bell measurement on the sacrificial pair"""

# ╔═╡ 36ad9694-e8b3-4c37-b4e2-30e94556ebdb
md"""This distillation procedure assumes access to perfect multi-qubit gates and measurements. Its yield is obtained through the entanglement entropy of the available states, namely

$$yield = 1 − S(\epsilon) = 1 − (1 − \epsilon) log(1 − \epsilon) − 2\epsilon log(\epsilon).$$"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DifferentialEquations = "~7.8.0"
Plots = "~1.38.16"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "22c543de5bb990d774166bdeb997f627a0f7f785"

[[deps.ADTypes]]
git-tree-sha1 = "dcfdf328328f2645531c4ddebf841228aef74130"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "0.1.3"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "76289dc51920fdc6e0013c872ba9551d54961c24"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.6.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra", "Requires", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "f83ec24f76d4c8f525099b2ac475fc098138ec31"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.4.11"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SnoopPrecompile", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e5f08b5689b1aad068e01751889f2f615c7db36d"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.29"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "1d9e98721e71dcf4db5a7d34f55d8aa07c43468f"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.0.6"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "PrecompileTools", "SparseArrays"]
git-tree-sha1 = "9ad46355045491b12eab409dee73e9de46293aa2"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "0.17.28"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "0c5f81f47bbbcf4aea7b2959135713459170798b"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.5"

[[deps.BoundaryValueDiffEq]]
deps = ["BandedMatrices", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase", "SparseArrays"]
git-tree-sha1 = "ed8e837bfb3d1e3157022c9636ec1c722b637318"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "2.11.0"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "89e0654ed8c7aebad6d5ad235d6242c2d737a928"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.3"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e30f2f4e20f7f186dc36529910beaedc60cfa644"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.16.0"

[[deps.ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "f84967c4497e0e1955f9a582c232b02847c5f589"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.7"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "70232f82ffaab9dc52585e0dd043b5e0c6b714f1"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.12"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "be6ab11021cd29f0344d5c4357b163af05a48cba"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.21.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "4e88377ae7ebeaf29a047aa1ee40826e0b708a5d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.7.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "96d823b94ba8d187a6d8f0826e731195a74b90e9"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.2.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "738fec4d684a9a6ee9598a8bfee305b26831f28c"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.2"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SimpleUnPack"]
git-tree-sha1 = "89f3fbfe78f9d116d1ed0721d65b0b2cf9b36169"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.42.0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "ChainRulesCore", "DataStructures", "Distributions", "DocStringExtensions", "EnumX", "FastBroadcast", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "Markdown", "MuladdMacro", "Parameters", "PreallocationTools", "Printf", "RecursiveArrayTools", "Reexport", "Requires", "SciMLBase", "SciMLOperators", "Setfield", "SparseArrays", "Static", "StaticArraysCore", "Statistics", "Tricks", "TruncatedStacktraces", "ZygoteRules"]
git-tree-sha1 = "62c41421bd0facc43dfe4e9776135fe21fd1e1b9"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.126.0"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "LinearAlgebra", "Markdown", "NLsolve", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "63b6be7b396ad395825f3cc48c56b53bfaf7e69d"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "2.26.1"

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "GPUArraysCore", "LinearAlgebra", "Markdown", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "Requires", "ResettableStacks", "SciMLBase", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "26594c6ec8416fb6ef3ed8828fd29c98b10bfaad"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.17.2"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqNoiseProcess", "JumpProcesses", "LinearAlgebra", "LinearSolve", "NonlinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "1cfe0178410e1bb4b14058c537d0f347eb9d95dc"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.8.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "49eba9ad9f7ead780bfb7ee319f962c811c6d3b2"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.8"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "db40d3aff76ea6a3619fdd15a8c78299221a2394"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.97"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "e90caa41f5a86296e014e148ee061bd6c3edec96"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.9"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterface", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "Printf", "SnoopPrecompile", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "fb7dbef7d2631e2d02c49e2750f7447648b0ec9b"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.24.0"

[[deps.ExprTools]]
git-tree-sha1 = "c1d06d129da9f55715c6c212866f5b1bddc5fa00"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.9"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "LinearAlgebra", "Polyester", "Static", "StaticArrayInterface", "StrideArraysCore"]
git-tree-sha1 = "d1248fceea0b26493fd33e8e9e8c553270da03bd"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.2.5"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastLapackInterface]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c1293a93193f0ae94be7cf338d33e162c39d8788"
uuid = "29a986be-02c6-4525-aec4-84b980013641"
version = "1.2.9"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "e17cc4dc2d0b0b568e80d937de8ed8341822de67"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.2.0"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "Setfield", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "c6e4a1fbe73b31a3dea94b1da449503b8830c306"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.21.1"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "00e252f4d706b3d55a8863432e742bf5717b498d"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.35"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "2d6ca471a6c7b536127afccfa7564b5b39227fe0"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.5"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8b8a2fd4536ece6e554168c21860b6820a8a83db"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.7"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "19fad9cd9ae44847fe842558a744748084a722d1"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.7+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "fb69b2a645fa69ba5f474af09221b9308b160ce6"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.3"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1cf1d7dcb4bc32d7b4a5add4232db3750c27ecb4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.8.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "2613d054b0e18a3dea99ca1594e9a3960e025da4"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.9.7"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "d38bd0d9759e3c6cfa19bdccc314eccf8ce596cc"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.15"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "0ec02c648befc2f94156eaef13b0f38106212f3f"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.17"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "6667aadd1cdee2c6cd068128b3d226ebc4fb0c67"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.9"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6f2675ef130a300a112286de91973805fcc5ffbc"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.91+0"

[[deps.JumpProcesses]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "StaticArrays", "TreeViews", "UnPack"]
git-tree-sha1 = "50bd271af7f6cc23be7d24c8c4804809bb5d05ae"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.6.3"

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "764164ed65c30738750965d55652db9c94c59bfe"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.4.0"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "0356a64062656b0cbb43c504ad5de338251f4bda"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.9.1"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f689897ccbe049adb19a065c495e75f372ecd42b"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.4+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "88b8f66b604da079a627b6fb2860d3704a6729a1"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.14"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[deps.LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "DocStringExtensions", "EnumX", "FastLapackInterface", "GPUArraysCore", "InteractiveUtils", "KLU", "Krylov", "LinearAlgebra", "PrecompileTools", "Preferences", "RecursiveFactorization", "Reexport", "Requires", "SciMLBase", "SciMLOperators", "Setfield", "SparseArrays", "Sparspak", "SuiteSparse", "UnPack"]
git-tree-sha1 = "c6a6f78167d7b7c19dfb7148161d7f1962a0b361"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "2.2.1"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "c3ce8e7420b3a6e071e0fe4745f5d4300e37b13f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.24"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "ArrayInterfaceCore", "CPUSummary", "ChainRulesCore", "CloseOpenIntervals", "DocStringExtensions", "ForwardDiff", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "SpecialFunctions", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "e4eed22d70ac91d7a4bf9e0f6902383061d17105"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.162"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.MuladdMacro]]
git-tree-sha1 = "cac9cc5499c25554cba55cd3c30543cff5ca4fab"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.4"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.NonlinearSolve]]
deps = ["ArrayInterface", "DiffEqBase", "EnumX", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "PrecompileTools", "RecursiveArrayTools", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SparseArrays", "SparseDiffTools", "StaticArraysCore", "UnPack"]
git-tree-sha1 = "2a7f28c62eb2c16b9c375c38f664cdcf22313cf5"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "1.8.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "82d7c9e310fe55aa54996e6f7f94674e2a38fcb4"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.9"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1aa4b74f80b01c6bc2b89992b861b5f210e665b5"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.21+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "e3a6546c1577bfd701771b477b794a52949e7594"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.6"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "d321bf2de576bf25ec4d3e4360faca399afca282"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.0"

[[deps.OrdinaryDiffEq]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "IfElse", "InteractiveUtils", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "LoopVectorization", "MacroTools", "MuladdMacro", "NLsolve", "NonlinearSolve", "Polyester", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLNLSolve", "SciMLOperators", "SimpleNonlinearSolve", "SimpleUnPack", "SparseArrays", "SparseDiffTools", "StaticArrayInterface", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "2aa75defe3eb7fcb0d914c0f7df907dbb8d63d3d"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.53.2"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "67eae2738d63117a196f497d7db789821bce61d1"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.17"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "f92e1315dadf8c46561fb9396e525f7200cdc227"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.5"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "75ca67b2c6512ad2d0c767a7cfc55e75075f8bbc"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.16"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PoissonRandom]]
deps = ["Random"]
git-tree-sha1 = "a0f1159c33f846aa77c3f30ebbc69795e5327152"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.4"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Requires", "Static", "StaticArrayInterface", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "0fe4e7c4d8ff4c70bfa507f0dd96fa161b115777"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.7.3"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "240d7170f5ffdb285f9427b92333c3463bf65bf6"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.1"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff", "Requires"]
git-tree-sha1 = "f739b1b3cc7b9949af3b35089931f2b58c289163"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.12"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "6ec7ac8412e83d57e313393220879ede1740f9ee"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.8.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "552f30e847641591ba3f39fd1bed559b9deb0ef3"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.6.1"

[[deps.RandomNumbers]]
deps = ["Random", "Requires"]
git-tree-sha1 = "043da614cc7e95c703498a491e2c21f58a2b8111"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.5.3"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "Requires", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "02ef02926f30d53b94be443bfaea010c47f6b556"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "2.38.5"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "SnoopPrecompile", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "9088515ad915c99026beb5436d0a09cd8c18163e"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.18"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "237edc1563bbf078629b4f8d194bd334e97907cf"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.11"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "4b8586aece42bee682399c4c4aee95446aa5cd19"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.39"

[[deps.SciMLBase]]
deps = ["ADTypes", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PrecompileTools", "Preferences", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables", "TruncatedStacktraces"]
git-tree-sha1 = "a22a12db91f6a921e28a7ae39a9546eed93fd92e"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "1.93.0"

[[deps.SciMLNLSolve]]
deps = ["DiffEqBase", "LineSearches", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "9dfc8e9e3d58c0c74f1a821c762b5349da13eccf"
uuid = "e9a6253c-8580-4d32-9898-8661bb511710"
version = "0.1.8"

[[deps.SciMLOperators]]
deps = ["ArrayInterface", "DocStringExtensions", "Lazy", "LinearAlgebra", "Setfield", "SparseArrays", "StaticArraysCore", "Tricks"]
git-tree-sha1 = "660322732becf934bf818792f9740984b375d300"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "0.3.1"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "30449ee12237627992a99d5e30ae63e4d78cd24a"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleNonlinearSolve]]
deps = ["ArrayInterface", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "PrecompileTools", "Reexport", "Requires", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "56aa73a93cdca493af5155a0338a864ed314222b"
uuid = "727e6d20-b764-4bd8-a329-72de5adea6c7"
version = "0.1.16"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleUnPack]]
git-tree-sha1 = "58e6353e72cde29b90a69527e56df1b5c3d8c437"
uuid = "ce78b400-467f-4804-87d8-8f486da07d0a"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "c60ec5c62180f27efea3ba2908480f8055e17cee"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SparseDiffTools]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "Reexport", "Requires", "SciMLOperators", "Setfield", "SparseArrays", "StaticArrayInterface", "StaticArrays", "Tricks", "VertexSafeGraphs"]
git-tree-sha1 = "4c1a57bcbc0b795fbfdc2009e70f9c2fd2815bfe"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "2.4.1"

[[deps.Sparspak]]
deps = ["Libdl", "LinearAlgebra", "Logging", "OffsetArrays", "Printf", "SparseArrays", "Test"]
git-tree-sha1 = "342cf4b449c299d8d1ceaf00b7a49f4fbc7940e7"
uuid = "e56a9233-b9d6-4f03-8d0f-1825330902ac"
version = "0.3.9"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "7beb031cf8145577fbccacd94b8a8f4ce78428d3"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.0"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "dbde6766fc677423598138a5951269432b0fcc90"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.8.7"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "Requires", "SnoopPrecompile", "SparseArrays", "Static", "SuiteSparse"]
git-tree-sha1 = "33040351d2403b84afce74dae2e22d3f5b18edcb"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.4.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "832afbae2a45b4ae7e831f86965469a24d1d8a83"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.26"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "45a7769a04a3cf80da1c1c7c60caf932e6f4c9f7"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.6.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "75ebe04c5bed70b91614d684259b661c9e6274a4"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.0"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "f625d686d5a88bcd2b15cd81f18f98186fdc0c9a"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.0"

[[deps.SteadyStateDiffEq]]
deps = ["DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "NLsolve", "Reexport", "SciMLBase"]
git-tree-sha1 = "564451a262696334a3bab19108a99dd90d5a22c8"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "1.15.0"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqNoiseProcess", "DocStringExtensions", "FillArrays", "FiniteDiff", "ForwardDiff", "JumpProcesses", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "ccf744171b3a83879158a4b3f3a430c1bc585123"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.61.1"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface", "ThreadingUtilities"]
git-tree-sha1 = "602a8bef17c744f1de965979398597dfa50e1a2f"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.4.15"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+0"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "PrecompileTools", "Reexport", "SciMLBase", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "a982ee85e1908d39f58d7fff670e60f991ca2ddb"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.19.0"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg", "SuiteSparse_jll"]
git-tree-sha1 = "04777432d74ec5bc91ca047c9e0e0fd7f81acdb6"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.1+0"

[[deps.SymbolicIndexingInterface]]
deps = ["DocStringExtensions"]
git-tree-sha1 = "f8ab052bfcbdb9b48fad2c80c873aa0d0344dfe5"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.2.2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "1544b926975372da01227b382066ab70e574a3ec"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "c97f60dd4f2331e1a495527f80d242501d2f9865"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.1"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "9a6ae7ed916312b41236fcef7e0af564ef934769"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.13"

[[deps.TreeViews]]
deps = ["Test"]
git-tree-sha1 = "8d0d7a3fe2f30d6a7f833a5f19f7c7a5b396eae6"
uuid = "a2a6695c-b41b-5b7d-aed9-dbfdeacea5d7"
version = "0.3.0"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "31eedbc0b6d07c08a700e26d31298ac27ef330eb"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.1.19"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.TruncatedStacktraces]]
deps = ["InteractiveUtils", "MacroTools", "Preferences"]
git-tree-sha1 = "7bc1632a4eafbe9bd94cf1a784a9a4eb5e040a91"
uuid = "781d530d-4396-4725-bb49-402e4bee1e77"
version = "1.3.0"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "ba4aa36b2d5c98d6ed1f149da916b3ba46527b2b"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.14.0"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "b182207d4af54ac64cbc71797765068fdeff475d"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.64"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.ZygoteRules]]
deps = ["ChainRulesCore", "MacroTools"]
git-tree-sha1 = "977aed5d006b840e2e40c0b48984f7463109046d"
uuid = "700de1a5-db45-46bc-99cf-38207098b444"
version = "0.2.3"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─970718ad-b2a6-4285-899e-ed29ffc8dc85
# ╟─4eb251c5-2323-4185-8320-d33316cbf047
# ╟─f1f6c0f6-8281-4ab5-b2b8-b0f1ba3c26e5
# ╟─45929b93-3ce5-4db3-a22a-423a28c8f32d
# ╟─01177799-1814-40da-ad12-05d5215642fd
# ╟─7920ef3e-d71e-45a5-8043-790dfb2022e7
# ╟─f833a02d-aba5-4046-9a66-2e7af298a793
# ╠═10209491-8d9f-4056-9358-09101e533dd5
# ╟─cdf312f8-2ed1-49f0-9b85-d3ad58b31ec7
# ╟─762c3311-da7f-4f0c-b7da-5df285f404cd
# ╟─cff02deb-0973-4a5c-b905-a38a48ec1e61
# ╟─ff17c447-bb69-4455-8819-6fa625addc7a
# ╟─387227e3-e4d9-4453-8845-b3c730999763
# ╟─1164cc37-2062-4ff9-8463-9edfb21db77a
# ╟─bf31c280-5e88-42d0-85bb-3ab11378aca1
# ╟─f2fbc3f0-8a51-43e6-8e15-15e2fa61124f
# ╟─91ce7b5d-cbcc-4cf5-8999-c2edd5e2bccf
# ╟─d09b3c71-8049-4bf6-b00f-0c93e438ec51
# ╟─76ba8fca-8425-4991-a04c-957c5748caa4
# ╟─c746c416-e559-45a3-84be-f21ab256a5a3
# ╟─5989cbc6-9e3e-46bf-9e70-8ea992629a9d
# ╟─ee358a4b-5c94-4bd1-b2a2-3c9846abf38f
# ╟─fdf8a09a-ff61-4f93-98eb-ceee6f99b1bc
# ╟─2f830af9-8d21-4b25-add5-6842f0ca0ba5
# ╟─2c03e491-a652-4548-afae-3384788c0b2b
# ╟─aa27c4d0-161c-44af-a235-8cffd0e17393
# ╟─21aebabf-c60f-444d-9d45-36df2ac3ab38
# ╟─71539848-3b56-4d37-a25d-85c6feb3c9c9
# ╟─a642d935-e0e4-4f89-ad12-083ab719f7dd
# ╟─b3004e4f-0963-483d-b70e-b5ead79791b8
# ╟─dcc5bb82-0418-4589-a036-073e23afbb1c
# ╟─6a3e0878-f0a8-49a5-a23d-3edf98c0fc56
# ╟─71d37f34-2163-4208-a106-54adff1b791c
# ╟─cfe37f4c-1c34-47a1-9984-e38a3433a5de
# ╟─ef75728f-0b9f-41ce-9b36-1689952858be
# ╟─e008a26b-f4b2-4106-b982-69bc34af0c4e
# ╟─fe0a2c93-b0d1-4e47-b760-feeea03a7ace
# ╟─ff33d221-ed21-4f84-83a9-83319f05b375
# ╟─c82a5807-ccba-41a7-b3c2-cd4e5bac0ecb
# ╟─c5a2437e-c77f-4a04-84ce-cb73a682fac5
# ╟─7ab52be5-fecd-440d-bd5d-60489ff10f3b
# ╟─7a602c0a-2615-44ad-af85-4e67f4ab1070
# ╟─ab51bd5c-a3a4-40ce-a4b1-343d5d938f8c
# ╟─393d4d88-da1a-4aba-bb82-ba1d3e8ec7a3
# ╟─e2d9c02f-d7aa-4d3a-9a1d-2a0ef14d74ad
# ╟─8dfaa441-de2e-47f4-869d-bf4471541b22
# ╟─ef86c88a-264b-4c5b-a916-0a5036d7c3ef
# ╟─ecedd49b-e036-4c9a-94c4-a8e119309dc2
# ╟─aa70bca1-61f0-4e60-937b-3b42a0b4d493
# ╟─7c96056a-1d20-4f69-b7c9-9c49d250fce4
# ╟─d146c7d9-94c3-4220-b2c3-7f9025a4c04d
# ╟─33571876-74b4-4a39-a541-f777880d7fce
# ╟─1d2966c0-9e43-44b7-af69-d355717d7353
# ╟─a5f936fb-9866-46ce-9c60-0ab21a67c961
# ╟─4136d7c6-3eda-4a80-9a44-8b57e7088b1c
# ╟─9b86f97f-8645-4074-9370-1ea4d204cb33
# ╟─9795091c-77b8-416d-8b58-adc0686dd4e6
# ╟─b5747e4f-a300-4705-80f7-2e5ec1184041
# ╟─b20c1921-9935-4013-b74e-830db0f82023
# ╟─fedf62db-d9f0-4edf-904e-bb14885ac80b
# ╟─9b170d18-9d9f-4863-b98b-4e8a8c6b836d
# ╟─8d76397d-7d0b-4fc3-9990-da676c5ae22b
# ╟─7082e2a0-486f-4803-89e2-409e91cb5a1a
# ╟─e9855f2c-8fc8-40c4-997a-a60a6da3d22b
# ╟─fa673ba6-677d-41b8-a60d-8519db356c61
# ╟─d9a0a623-03f9-458d-ab99-fe8a0446ed3c
# ╟─0ed17d30-ca8d-4ccc-bcd7-09c63cec38e0
# ╟─d42743b8-7a16-4445-adfd-82809b1d9d58
# ╟─63bb7260-a5b2-4206-9d5c-77684ecfdf36
# ╟─b0f49879-df51-44b4-99a9-603f338ad884
# ╟─2a0e2d1d-6e6e-4081-99bb-ca6eaf696399
# ╟─d11bc08a-641d-426e-8999-805e93afc6ba
# ╟─e81ca2e2-24f4-4f3c-aa0f-11a9ca9b00f1
# ╟─02543f9e-0fb1-4f6d-8290-1a14e6fd4ecd
# ╟─c6d24b06-f1aa-4733-969c-a153aae99257
# ╟─36ad9694-e8b3-4c37-b4e2-30e94556ebdb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
