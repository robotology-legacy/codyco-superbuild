CoDyCo notation primer for Whole-Body Dynamics Computations   {#dynamics_notation}
==================================================
This documents try to explain the notation that is used in most of the CoDyCo software,
for example the wholeBodyInterface (WBI) or WBI Toolbox.

Prerequisites
-------------
This documents assumes that the reader has a basic knowledge of robot kinematics and dynamics.

As a reference to the notation used in this document, the reader is **strongly recommended** to read the first two Chapters ( Kinematics and Dynamics ) of the Springer Handbook of Robotics.

### Spatial vectors, Plucker coordinates and common misunderstandings
A working knoledge of spatial vector notation, as used in Chapter 2 of the Springer Robotics Handbook, is required to get
a basic understanding of the content of this document.

To get a basic introduction to spatial algebra you can check the nice tutorial in two parts by Roy Featherstone,
originally published on IEEE Robotics & Automation Magazine:
  - [A Beginner's Guide to 6-D Vectors (Part 1)](http://dx.doi.org/10.1109/MRA.2010.937853)
  - [A Beginner's Guide to 6-D Vectors (Part 2)](http://dx.doi.org/10.1109/MRA.2010.939560)

Additional resources, examples and slides are available on [Roy Featherstone website](http://royfeatherstone.org/spatial/).

#### Generalization of Featherstone coordinate frame notation

##### Motion 6-D vectors
As previously stated in this document, we try to follow the notation used in the Dynamics Chapter of the Handbook of Robotics.
However we extend this notation to avoid some common musunderstandings.
In the Handbook a twist \f$\mathbf{v}\f$ of a body \f$B\f$ expressed in a given coordinate frame \f$w\f$ is indicated with:
\f$ {}^w\mathbf{v} \f$ .
In a nutshell this notation means that:
  * the linear and angular parts of the twist are expressed using the orientation of frame \f$w\f$,
  * the linear part of the twist is linear velocity of the point of body \f$B\f$ instantaneously coincident with the origin of the frame \f$w\f$.
Often in control is useful to separate this two notions, namely the orientation and the reference points with respect to which a quantity is expressed.

For this reason we prefer to use a extendend notation, namely to express the coordinates of a twist as
\f[
{}^{w,l}\mathbf{v}
\f]
where:
  * the linear and angular parts of the twist are oriented using the orientation of frame \f$w\f$,
  * the linear part of the twist is linear velocity of the point of body \f$B\f$ instantaneously coincident with the origin of the frame \f$l\f$.
If the frame \f$l\f$ is then attached to the body \f$B\f$ the linear part is simply the velocity of the origin of frame \f$ l \f$.

##### Force 6-D vectors

Similarly, a wrench applied to a body \f$B\f$ expressed in a given coordinate frame \f$w\f$ is indicated with:
\f$ {}^w\mathbf{f} \f$
In a nutshell this notation means that:
  * the linear (force) and angular (torque) parts of the twist are expressed using the orientation of frame \f$w\f$,
  * the reference point for the angular (torque) part of thre wrench is the origin of frame \f$w\f$.

Often in control is useful to separate this two notions, namely the orientation and the reference points with respect to which a quantity is expressed.
For this reason we prefer to use a extendend notation, namely to express the coordinates of a twist as
\f[
{}^{w,l}\mathbf{f}
\f]
 where:
  * the linear and angular parts of the wrench are expressed using the orientation of frame \f$w\f$,
  * the reference point for the angular (torque) part of thre wrench is the origin of frame \f$l\f$.

### Spatial acceleration, classical acceleration and all the friends
If you have read Chapter 2 of the Robotics Handbook you should know what the difference between
spatial and classical acceleration is.
This is a common point of confusion, so if you want to read more on the difference definitions
of rigid body acceleration you can read about them on Rigid Body Dynamics Algorithms, Chapter 2 Section 11.
Further explanation is provided in this article by Roy Featherstone:
  - [The Acceleration Vector of a Rigid Body](http://ijr.sagepub.com/content/20/11/841.short)

### Free Floating Robots
A free floating robot is composed by \f$n_l\f$ links connected by \f$n_{dof}\f$ degrees of freedom.
The set of the links is indicated by $L$.
We call \f$l\f$ the frame attached to each link \f$l\f$. Similarly we postulate the
existance of a inertial frame \f$w\f$.

#### Position
The pose of every link with respect to the other links of the robot (relative pose) is uniquely  determined by the joint positions. The joint positions are usually indicated by a vector \f$\mathbf{q}_j \in \mathbb{R}^{n_{dof}}\f$.

To fully specify the position of the free floating robot with respect to the world inertial frame, we need an additional information: the pose of one link with respect to the world. This link is usually called the **floating base** of the robot.

The pose of this **floating base** with respect to the world reference frame is indicated with \f${}^wT_b\f$. As \f${}^wT_b\f$ is an element of special Euclidean group \f$SE(3)\f$ a appropriate choice of the parametrization has to be done. Depending on the chosen parametrization, the dimension of \f$\mathbf{q}_b\f$ can vary. (Reference to jain, mujoco, kheddar)

By abuse of notation, we define \f$\mathbf{q}\f$ as the vector obtained by stacking \f$ {}^wT_b \f$ and \f$ \mathbf{q}_j \f$:
\f[
\mathbf{q} = \begin{bmatrix} {}^wT_b\ \\ \mathbf{q}_j \end{bmatrix} \in \mathbb{R}^{n_{dof}+m}
\f]

Where \f$m \f$ is the dimension of the used parametrization of \f$SE(3)\f$.

While in papers and reports is convenient to manipulate \f$\mathbf{q}\f$ as a
vector, in software is it often more convenient to use high level objects to represent \f$\mathbf{q}\f$ or \f${}^wT_b \f$, that permit to abstract the particular representation used to express \f${}^wT_b \f$.
A good example of such high level object is the KDL::Frame provided by the KDL library. The wbi::Frame class of the wholeBodyInterface is just a local fork of KDL::Frame.

For a given link \f$l\f$ from \f$\mathbf{q}\f$ it is possible to compute its pose with respect to the world reference frame:
\f[
{}^w \mathbf{T}_l = {}^w \mathbf{T}_l(\mathbf{q}),
\f]
if in this case \f$ {}^w \mathbf{T}_l \f$ stand for an homogeneous 4x4 matrix representing the rototranslation between frame \f$l\f$ and frame \f$w\f$.
This function is called **forward kinematics**.

#### Velocity
The twist of every link with respect to the other links of the robot (relative twist) is uniquely  determined by the joint positions and joint velocities. The joint velocities are indicated with \f$\dot{\mathbf{q}}_j \in \mathbb{R}^{n_j}\f$.

To fully specify the velocity of the free floating robot with respect to the world inertial frame, we need an additional information: the twist of a link, usually the same \emph{floating base} used for defining the position configuration. We indicates this twist of the floating base as:
\f[
{}^{w,b}\mathbf{v}_b .
\f]

As for position, we can then define the generalized joint velocity of the free flyng robot as:
\f[
\mathbf{v} = \begin{bmatrix} {}^{w,b}\mathbf{v}_b \\ \dot{\mathbf{q}}_j \end{bmatrix} \in \mathbb{R}^{n_{dof}+6}
\f]
Note that \f$\mathbf{v}\f$ is not the derivative of \f$\mathbf{q}\f$, and they can even have different dimension, depending
on the parametrization used for representing the floating base position \f${}^w\mathbf{T}_b\f$

The twist of a given link is linear with respect to the generalized joint velocity \mathbf{v}:
\f[
{}^{w,l}\mathbf{v}_l  = {}^{w,l}\mathbf{J}_l(\mathbf{q}) \mathbf{v}
\f]
this function is called **forward instantaneous kinematics** or **forward differential kinematics**.


#### Acceleration
The joint accelerations are indicated \f$\ddot{\mathbf{q}}_j\f$.
We indicate the floating base classical acceleration vector as \f$ \dot{({}^{w,b}\mathbf{v}_b)} \f$.
It is important to noticed that this is vector is concatenation of two 3D vectors, both expressed using
 the orientation of the world inertial frame \f$w\f$:
 * the 3D acceleration of the origin of frame \f$b\f$,
 * the 3D angular acceleration of the frame \f$b\f$.

It should be stressed once more that this is **not the derivative of the velocity twist**, which is classicaly
dubbed "spatial acceleration" (and indicated as \f$ ({}^{w,b}\dot{\mathbf{v}}_b) \f$, notice that in this case the dot is on
the twist itself, not on coordinate representation.

For further information of this difference, please refer to [The Acceleration Vector of a Rigid Body](http://ijr.sagepub.com/content/20/11/841.short).

As for position and velocity, we can then define the generalized joint acceleration of the free flying robot as:
\f[
\dot{\mathbf{v}} = \begin{bmatrix}  \dot{({}^{w,b}\mathbf{v}_b)} \ \\ \ddot{\mathbf{q}}_j \end{bmatrix} \in {R}^{n_{dof}+6}
\f]

#### Dynamics
The \f$ 6+n_{dof} \f$ dynamics equations of a free floating robot can then be written as:
\f[
\mathbf{M}(\mathbf{q})\dot{\mathbf{v}} + \mathbf{C}(\mathbf{q},\mathbf{v})\mathbf{v} + \mathbf{g}(\mathbf{q}) = \mathbf{S}^\top \boldsymbol\tau + \sum_{l \in L} {}^{w,l}\mathbf{J}_{l}^\top {}^{w,l}\mathbf{f}_l^{ext}
\f]
where:
  * \f$ \mathbf{M}(\mathbf{q}) \in \mathbb{R}^{6+n_{dof} \times 6+n_{dof}} \f$ is the floating base mass matrix,
  * \f$ \mathbf{C}(\mathbf{q},\mathbf{v})\mathbf{v} \in  \mathbb{R}^{6+n_{dof}} \f$ is the vector of coriolis generalized torques,
  * \f$ \mathbf{g}(\mathbf{q}) \in \mathbb{R}^{6+n_{dof}} \f$ is the vector or gravity generalized torques,
  * \f$ \mathbf{S} = \begin{bmatrix} \mathbf{0}_{n_{dof} \times 6} && \mathbf{I}_{n_{dof} \times n_{dof}}  \end{bmatrix} \in \mathbb{R}^{n_{dof} \times 6+n_{dof}} \f$ is a selection matrix,
  * \f$ \boldsymbol\tau \in \mathbb{R}^{n_{dof}} \f$ is the vector of the joint torques excerted on multi body system,
  * \f$ {}^{w,l}\mathbf{f}_l^{ext} \in \mathbb{R}^{6} \f$ is the wrench excerted by external enviroment on link \f$l\f$.

