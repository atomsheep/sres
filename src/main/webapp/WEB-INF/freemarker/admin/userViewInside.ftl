
<#if obj??>
      <div>
      <span>ID</span>
      <span>${obj.id}</span>
      </div>
      <div>
      <span>User Name</span>
      <span>${obj.userName}</span>
      </div>
      <div>
      <span>Pass Word</span>
      <span>${obj.passWord}</span>
      </div>
      <div>
      <span>Where Are You From</span>
      <span>${obj.wayf}</span>
      </div>
      <div>
      <span>First Name</span>
      <span>${obj.firstName}</span>
      </div>
      <div>
      <span>Last Name</span>
      <span>${obj.lastName}</span>
      </div>
      <div>
      <span>Email Address</span>
      <span>${obj.email}</span>
      </div>
      <div>
      <span>Login Times</span>
      <span>${obj.loginTimes}</span>
      </div>
      <div>
      <span>First Login Time</span>
      <span>${obj.firstLoginTime}</span>
      </div>
      <div>
      <span>Last Login Time</span>
      <span>${obj.lastLoginTime}</span>
      </div>
      <div>
      <span>Last Login IP</span>
      <span>${obj.lastLoginIP}</span>
      </div>
      <div>
      <span>Online Time(ms)</span>
      <span>${obj.onlineTime}</span>
      </div>
      <div>
      <span>Is this user a guest?</span>
      <span>${obj.isGuest}</span>
      </div>
      <div>
      <span>Disabled access?</span>
      <span>${obj.disabled}</span>
      </div>
      <div>
      <span>Unique Code</span>
      <span>${obj.uniqueCode}</span>
      </div>
      <div>
      <span>School</span>
      <span>${obj.school}</span>
      </div>
      <div>
      <span>Year</span>
      <span>${obj.year}</span>
      </div>
      <div>
      <span>Run</span>
      <span>${obj.run}</span>
      </div>
<#else>
no object found.
</#if>