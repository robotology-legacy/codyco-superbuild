CoDyCo notation primer for Whole-Body Dynamics Computations   {#dynamics_notation}
==================================================
This documents try to explain the notation that is used in most of the CoDyCo software,
for example the wholeBodyInterface (WBI) or WBI Toolbox.

Prerequisites
-------------
This documents assumes that the reader has a basic knowledge of robot kinematics and dynamics.

As a reference to the notation used in this document, the reader is **strongly recommended** to read the first two Chapters ( Kinematics and Dynamics ) of the Springer Handbook of Robotics.

### Spatial vectors, Plucker coordinates and common misunderstandings
Explain plucker coordinates to address usually misunderstanding.

A basic explanation of Spatial vectors should be given in Chapter 2 of the Springer Robotics Handbook, however
this section will clarify common misunderstandings and obscure points.
In the meanwhile you can check the nice tutorial in two parts by Roy Featherstone, originally published on IEEE Robotics & Automation Magazine:
  - [A Beginner's Guide to 6-D Vectors (Part 1)](http://dx.doi.org/10.1109/MRA.2010.937853)
  - [A Beginner's Guide to 6-D Vectors (Part 2)](http://dx.doi.org/10.1109/MRA.2010.939560)
Additional resources, examples and slides are available on [Roy Featherstone website](http://royfeatherstone.org/spatial/).

Todo: add explanation of relationship between Featherstone Notation and Siciliano Sciavicco one. Consider the use of Leuven standard semantics as a lingua franca.
### Spatial acceleration, classical acceleration and all the friends
If you read Chapter 2 of the Robotics Handbook you should know what the difference between
spatial and classical acceleration is.
This is a common point of confusion, so if you want to read more on the difference definitions
of rigid body acceleration you can read about them on Rigid Body Dynamics Algorithms, Chapter 2 Section 11.
Further explanation is provided in this article by Roy Featherstone:
  - [The Acceleration Vector of a Rigid Body]((http://ijr.sagepub.com/content/20/11/841.short)

### Free Floating Robots
A free floating robot is composed by \f$n_l\f$ links connected by \f$n_j\f$ joints.
If we assume that each joint has only one degree of freedom, we can also assume that
the number of internal degrees of freedom of the robot are equal to the number of joints ($n_{dof} = n_j$).

#### Position
The pose of every link with respect to the other links of the robot (relative pose) is uniquely  determined by the joint positions. The joint positions are usually indicated by a vector \f$\mathbf{q}_j \in \mathbb{R}^{n_j}\f$.

To fully specify the position of the free floating robot with respect to the world frame, we need an additional information: the pose of one link with respect to the world. This link is usually called the **floating base** of the robot.

The pose of this **floating base** with respect to the world reference frame is indicated with \f$\mathbf{q}_b\f$. As \f$\mathbf{q}_b\f$ is an element of special Euclidean group $SE(3)$ a appropriate choice of the parametrization has to be done. Depending on the chosen parametrization, the dimension of \f$\mathbf{q}_b\f$ can vary. (Reference to jain, mujoco, kheddar)

By abuse of notation, we define \f$\mathbf{q}\f$ as the vector obtained by stacking \f$\mathbf{q}_b\f$ and \f$\mathbf{q}_f\f$:
\f[
\mathbf{q} = \begin{bmatrix} \mathbf{q}_b \\ \mathbf{q}_j \end{bmatrix} \in \mathbb{R}^{n_j+m}
\f]

Where $m$ is the dimension of the used parametrization of \f$SE(3)\f$.

While in papers and reports is convenient to manipulate \f$\mathbf{q}\f$ as a
vector, in software is it often more convenient to use high level objects to represent \f$\mathbf{q}\f$ or \f$\mathbf{q}_b\f$, that permit to abstract the particular representation used to express \f$\mathbf{q}_b\f$.
A good example of such high level object is the ''KDL::Frame'' provided by the KDL library. The ''wbi::Frame'' class of the wholeBodyInterface is just a local fork of ''KDL::Frame''.

For a given link \f$l\f$ from \f$\mathbf{q}\f$ it is possible to compute its pose with respect to the world reference frame:
\f[
{}^w \mathbf{T}_l = {}^w \mathbf{T}_l(\mathbf{q}),
\f]
this function is called **forward kinematics**.

#### Velocity
The twist of every link with respect to the other links of the robot (relative twist) is uniquely  determined by the joint positions and joint velocities. The joint velocities are indicated with \f$\dot{\mathbf{q}}_j \in \mathbb{R}^{n_j}\f$.

To fully specify the velocity of the free floating robot with respect to the world frame, we need an additional information: the twist of a link, usually the same \emph{floating base} used for defining the position configuration. We indicates this twist of the floating base as:
\f[
\dot{\mathbf{q}}_b = {}^{b,w}\mathbf{v}_b .
\f]
The use of the dot in this case is a conventient abuse of notation because the base twist is not the derivative of the \f$\mathbf{q}_b\f$.

As for position, we can then define the generalized joint velocity of the free flyng robot as:
\f[
\dot{\mathbf{q}} = \begin{bmatrix} \dot{\mathbf{q}}_b \\ \dot{\mathbf{q}}_j \end{bmatrix} \in \mathbb{R}^{n_j+6}
\f]

The twist of a given link is linear with respect to the generalized joint velocity:
\f[
{}^{l,w}\mathbf{v}_l  = \mathbf{J}_l(\mathbf{q}) \dot{\mathbf{q}}
\f]
this function is called **forward instantaneous kinematics** or **forward differential kinematics**.


#### Acceleration
The joint accelerations are indicated \f$\ddot{\mathbf{q}}_j\f$, while the floating base acceleration twist is indicated with \f$\ddot{\mathbf{q}}_b\f$.



As for position and velocity, we can then define the generalized joint acceleration of the free flying robot as:
\f[
\ddot{\mathbf{q}} = \begin{bmatrix} \ddot{\mathbf{q}}_b \\ \ddot{\mathbf{q}}_j \end{bmatrix} \in \mathbb{R}^{n_j+6}
\f]

#### Dynamics
The dynamics of a free floating robot can then be written as:
\f[
\mathbf{M}(\mathbf{q})\ddot{\mathbf{q}} + \mathbf{C}(\mathbf{q},\dot{\mathbf{q}}) + \mathbf{g}(\mathbf{q}) = \mathbf{S}^\top \boldsymbol\tau + \sum_{c=1}^{N_C} \mathbf{J}_{c}^\top \mathbf{f}_c
\f]


